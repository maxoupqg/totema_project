class_name GestionnaireCombat
extends Node2D

signal combat_termine(victoire: bool)

enum EtatCombat { EN_ATTENTE, TOUR_JOUEUR, CHOIX_CIBLE, TOUR_TOTEM, TOUR_ENNEMI, TERMINE }
enum ActionEnAttente { AUCUNE, ATTAQUE, MAGIE }

@onready var joueur: Joueur = $Combattants/Joueur
@onready var totem: Totem = $Combattants/Totem
@onready var combattants_node: Node2D = $Combattants
@onready var fusion: Fusion = $Fusion
@onready var btn_attaque: Button = $UI/PanelActions/VBoxContainer/BtnAttaque
@onready var btn_defense: Button = $UI/PanelActions/VBoxContainer/BtnDefense
@onready var btn_magie: Button = $UI/PanelActions/VBoxContainer/BtnMagie
@onready var btn_fuir: Button = $UI/PanelActions/VBoxContainer/BtnFuir
@onready var btn_fusionner: Button = $UI/PanelActions/VBoxContainer/BtnFusionner
@onready var btn_ressusciter: Button = $UI/PanelActions/VBoxContainer/BtnRessusciter
@onready var panel_cibles: Panel = $UI/PanelCibles
@onready var vbox_cibles: VBoxContainer = $UI/PanelCibles/VBoxCibles
@onready var journal: RichTextLabel = $UI/JournalCombat
@onready var label_tour: Label = $UI/LabelTour
@onready var label_fusion: Label = $UI/LabelFusion

var ennemis: Array[Ennemi] = []
var etat: EtatCombat = EtatCombat.EN_ATTENTE
var action_en_attente: ActionEnAttente = ActionEnAttente.AUCUNE
var _index_ennemi_courant: int = 0
var _couleur_joueur_originale: Color

func _ready() -> void:
	# Collecte tous les Ennemi sous Combattants
	for noeud in combattants_node.get_children():
		if noeud is Ennemi:
			ennemis.append(noeud)
			noeud.mort.connect(_sur_mort_ennemi.bind(noeud))

	joueur.mort.connect(_sur_mort_joueur)
	totem.mort.connect(_sur_mort_totem)
	fusion.jauge_change.connect(_sur_jauge_change)

	btn_attaque.pressed.connect(_action_attaque)
	btn_defense.pressed.connect(_action_defense)
	btn_magie.pressed.connect(_action_magie)
	btn_fuir.pressed.connect(_action_fuir)
	btn_fusionner.pressed.connect(_action_fusionner)
	btn_ressusciter.pressed.connect(_action_ressusciter)

	panel_cibles.visible = false
	_demarrer_combat()

func _demarrer_combat() -> void:
	_maj_label_fusion()
	_log("=== Combat commence ! ===")
	_debut_tour_joueur()

func _debut_tour_joueur() -> void:
	joueur.reinitialiser_tour()
	etat = EtatCombat.TOUR_JOUEUR
	_activer_boutons(true)
	btn_fusionner.disabled = fusion.en_fusion or fusion.jauge < fusion.jauge_max or not totem.est_vivant()
	btn_ressusciter.disabled = totem.est_vivant()
	if fusion.en_fusion:
		label_tour.text = "Ton tour [Fusion x%d]" % fusion.tours_restants
	else:
		label_tour.text = "Ton tour"
	_log("--- Ton tour ---")

func _activer_boutons(actif: bool) -> void:
	btn_attaque.disabled = not actif
	btn_defense.disabled = not actif
	btn_magie.disabled = not actif
	btn_fuir.disabled = not actif
	btn_fusionner.disabled = not actif
	btn_ressusciter.disabled = not actif

# — Sélection de cible —

func _afficher_selection_cible() -> void:
	etat = EtatCombat.CHOIX_CIBLE
	for enfant in vbox_cibles.get_children():
		if enfant.name != "LabelTitre":
			enfant.queue_free()
	for cible in ennemis:
		if cible.est_vivant():
			var btn: Button = Button.new()
			btn.text = "%s  (%d/%d PV)" % [cible.nom_combattant, cible.pv_actuels, cible.pv_max]
			btn.pressed.connect(_sur_cible_choisie.bind(cible))
			vbox_cibles.add_child(btn)
	var btn_annuler: Button = Button.new()
	btn_annuler.text = "Annuler"
	btn_annuler.pressed.connect(_annuler_selection_cible)
	vbox_cibles.add_child(btn_annuler)
	panel_cibles.visible = true
	label_tour.text = "Choisir une cible..."

func _annuler_selection_cible() -> void:
	panel_cibles.visible = false
	action_en_attente = ActionEnAttente.AUCUNE
	etat = EtatCombat.TOUR_JOUEUR
	_activer_boutons(true)
	btn_fusionner.disabled = fusion.en_fusion or fusion.jauge < fusion.jauge_max or not totem.est_vivant()
	label_tour.text = "Ton tour"

func _sur_cible_choisie(cible: Ennemi) -> void:
	panel_cibles.visible = false
	match action_en_attente:
		ActionEnAttente.ATTAQUE:
			var degats: int = joueur.attaquer(cible)
			_log("Tu attaques %s pour %d dégâts." % [cible.nom_combattant, degats])
			fusion.ajouter_points(degats)
		ActionEnAttente.MAGIE:
			var degats: int = joueur.lancer_sort(cible)
			_log("Tu lances un sort sur %s pour %d dégâts." % [cible.nom_combattant, degats])
			fusion.ajouter_points(degats)
	action_en_attente = ActionEnAttente.AUCUNE
	_appliquer_bonus_fusion()
	_fin_tour_joueur()

# — Actions joueur —

func _action_attaque() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	action_en_attente = ActionEnAttente.ATTAQUE
	_afficher_selection_cible()

func _action_defense() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	joueur.defendre()
	_log("Tu te mets en défense (dégâts réduits de moitié).")
	_appliquer_bonus_fusion()
	_fin_tour_joueur()

func _action_magie() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	action_en_attente = ActionEnAttente.MAGIE
	_afficher_selection_cible()

func _action_fuir() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	if joueur.tenter_fuite():
		_log("Tu fuis le combat !")
		etat = EtatCombat.TERMINE
		label_tour.text = "Fuite !"
		emit_signal("combat_termine", false)
	else:
		_log("Impossible de fuir !")
		_appliquer_bonus_fusion()
		_fin_tour_joueur()

func _action_fusionner() -> void:
	if etat != EtatCombat.TOUR_JOUEUR or fusion.en_fusion or fusion.jauge < fusion.jauge_max or not totem.est_vivant():
		return
	_activer_boutons(false)
	fusion.activer()
	_maj_label_fusion()
	# Visuel : le totem disparaît et fusionne avec le joueur (couleur mélangée)
	_couleur_joueur_originale = joueur.couleur
	joueur.couleur = joueur.couleur.lerp(totem.couleur, 0.5)
	joueur.queue_redraw()
	totem.visible = false
	_log("=== FUSION ! Le Totem et toi ne font plus qu'un (%d tours) ===" % fusion.duree_fusion)
	_fin_tour_joueur()

func _action_ressusciter() -> void:
	if etat != EtatCombat.TOUR_JOUEUR or totem.est_vivant():
		return
	_activer_boutons(false)
	totem.pv_actuels = totem.pv_max / 2
	totem.visible = true
	totem.queue_redraw()
	fusion.reduire_jauge(0.2)
	_maj_label_fusion()
	totem._modifier_agitation(-20)
	_log("Tu ressuscites le Totem ! Il revient à %d/%d PV. (fusion -20%%, agitation -20)" % [totem.pv_actuels, totem.pv_max])
	_appliquer_bonus_fusion()
	_fin_tour_joueur()

# — Bonus fusion —

func _appliquer_bonus_fusion() -> void:
	if not fusion.en_fusion:
		return
	if not totem.est_vivant():
		fusion.tours_restants = 0
		fusion.en_fusion = false
		_log("--- La fusion se termine (totem hors combat) ---")
		_maj_label_fusion()
		joueur.couleur = _couleur_joueur_originale
		joueur.queue_redraw()
		return
	match totem.type_axe:
		Totem.TypeAxe.AGITATION:
			# Soin fiable et amplifié après chaque action
			var soin: int = min(fusion.soin_fusion, joueur.pv_max - joueur.pv_actuels)
			joueur.pv_actuels += soin
			joueur.queue_redraw()
			_log("[Fusion] Le Totem te soigne de %d PV !" % soin)
		Totem.TypeAxe.COLERE:
			# L'effet se produit côté ennemi (voir _executer_tour_ennemi)
			_log("[Fusion Colère] Actif — les ennemis brûlent quand ils te frappent.")
		Totem.TypeAxe.PEUR:
			# L'effet se produit côté ennemi (voir _executer_tour_ennemi)
			_log("[Fusion Peur] Actif — le Totem esquive et contre-attaque.")
	fusion.decrementer_tour()
	if not fusion.en_fusion:
		_log("--- La fusion se termine ---")
		_maj_label_fusion()
		joueur.couleur = _couleur_joueur_originale
		joueur.queue_redraw()
		totem.visible = true

# — Enchaînement des tours —

func _fin_tour_joueur() -> void:
	if _tous_ennemis_morts():
		return
	etat = EtatCombat.TOUR_TOTEM
	label_tour.text = "Tour du Totem..."
	await get_tree().create_timer(0.8).timeout
	_tour_totem()

func _tour_totem() -> void:
	if totem.est_vivant() and not fusion.en_fusion:
		var cible_ennemi: Combattant = _premier_ennemi_vivant()
		if cible_ennemi != null:
			_log("--- Tour du Totem [%s] ---" % _nom_palier(totem.agitation))
			var decision: Dictionary = totem.jouer_tour(joueur, cible_ennemi)
			_log_action_totem(decision)
			if _tous_ennemis_morts():
				return
	etat = EtatCombat.TOUR_ENNEMI
	label_tour.text = "Tour des ennemis..."
	await get_tree().create_timer(0.8).timeout
	_debut_tours_ennemis()

func _debut_tours_ennemis() -> void:
	_index_ennemi_courant = 0
	_prochain_tour_ennemi()

func _prochain_tour_ennemi() -> void:
	# Avance au prochain ennemi vivant
	while _index_ennemi_courant < ennemis.size() and not ennemis[_index_ennemi_courant].est_vivant():
		_index_ennemi_courant += 1
	if _index_ennemi_courant >= ennemis.size():
		if joueur.est_vivant():
			_debut_tour_joueur()
		return
	var ennemi_actif: Ennemi = ennemis[_index_ennemi_courant]
	_index_ennemi_courant += 1
	_log("--- Tour de %s ---" % ennemi_actif.nom_combattant)
	await get_tree().create_timer(0.6).timeout
	_executer_tour_ennemi(ennemi_actif)

func _executer_tour_ennemi(ennemi_actif: Ennemi) -> void:
	var cibles: Array[Combattant] = []
	if joueur.est_vivant():
		cibles.append(joueur)
	if totem.est_vivant() and not fusion.en_fusion:
		cibles.append(totem)
	if cibles.is_empty():
		return
	# Les ennemis avec preference_totem ciblent le totem en priorité si disponible
	var cible: Combattant
	if totem.est_vivant() and not fusion.en_fusion and randf() < ennemi_actif.preference_totem:
		cible = totem
	else:
		cible = cibles[randi() % cibles.size()]

	# Peur hors fusion : esquive ou redirection selon le flag actif
	if totem.est_vivant() and not fusion.en_fusion:
		if cible == totem and totem.esquive_active:
			totem.esquive_active = false  # consommé : une esquive par tour
			var contre: int = totem.degats_base
			ennemi_actif.pv_actuels = max(0, ennemi_actif.pv_actuels - contre)
			ennemi_actif.queue_redraw()
			fusion.ajouter_points(contre)
			_log("%s attaque le Totem — il esquive et contre-attaque pour %d dégâts !" % [ennemi_actif.nom_combattant, contre])
			_prochain_tour_ennemi()
			return
		elif cible == totem and totem.esquive_simple:
			totem.esquive_simple = false  # consommé : une esquive par tour
			_log("%s attaque le Totem — il esquive !" % ennemi_actif.nom_combattant)
			_prochain_tour_ennemi()
			return
		elif cible == totem and totem.protection_egoiste:
			# Non consommé : redirige TOUS les coups ce tour vers le joueur
			cible = joueur
			_log("%s attaque le Totem — il esquive et te redirige le coup !" % ennemi_actif.nom_combattant)

	# Fusion Peur : esquive totale + contre-attaque sur chaque frappe ennemie
	if fusion.en_fusion and totem.type_axe == Totem.TypeAxe.PEUR and cible == joueur and totem.est_vivant():
		var contre: int = totem.degats_base
		ennemi_actif.pv_actuels = max(0, ennemi_actif.pv_actuels - contre)
		ennemi_actif.queue_redraw()
		_log("%s attaque — [Fusion Peur] Esquive ! Contre-attaque : %d dégâts sur %s !" % [ennemi_actif.nom_combattant, contre, ennemi_actif.nom_combattant])
		_prochain_tour_ennemi()
		return

	var degats: int = ennemi_actif.jouer_tour(cible)
	_log("%s frappe %s pour %d dégâts%s." % [
		ennemi_actif.nom_combattant, cible.nom_combattant, degats,
		" (réduit)" if cible.en_defense else ""
	])

	# Fusion Colère : l'attaquant brûle en frappant le joueur
	if fusion.en_fusion and totem.type_axe == Totem.TypeAxe.COLERE and cible == joueur:
		var brulure: int = max(1, degats)
		ennemi_actif.pv_actuels = max(0, ennemi_actif.pv_actuels - brulure)
		ennemi_actif.queue_redraw()
		_log("[Fusion Colère] %s brûle pour %d dégâts en retour !" % [ennemi_actif.nom_combattant, brulure])

	if not joueur.est_vivant():
		return
	_prochain_tour_ennemi()

# — Handlers de mort —

func _sur_mort_joueur() -> void:
	if etat == EtatCombat.TERMINE:
		return
	etat = EtatCombat.TERMINE
	panel_cibles.visible = false
	_activer_boutons(false)
	label_tour.text = "Défaite..."
	_log("=== Tu es vaincu. ===")
	emit_signal("combat_termine", false)

func _sur_mort_totem() -> void:
	_log("Le Totem est hors de combat !")

func _sur_mort_ennemi(ennemi_mort: Ennemi) -> void:
	_log("%s est vaincu !" % ennemi_mort.nom_combattant)
	if not _tous_ennemis_morts():
		return
	if etat == EtatCombat.TERMINE:
		return
	etat = EtatCombat.TERMINE
	_activer_boutons(false)
	panel_cibles.visible = false
	label_tour.text = "Victoire !"
	_log("=== Tous les ennemis sont vaincus ! Victoire ! ===")
	emit_signal("combat_termine", true)

# — Helpers —

func _tous_ennemis_morts() -> bool:
	for e in ennemis:
		if e.est_vivant():
			return false
	return true

func _premier_ennemi_vivant() -> Ennemi:
	for e in ennemis:
		if e.est_vivant():
			return e
	return null

func _sur_jauge_change(_valeur: int, _max: int) -> void:
	_maj_label_fusion()
	if not fusion.en_fusion and etat == EtatCombat.TOUR_JOUEUR:
		btn_fusionner.disabled = fusion.jauge < fusion.jauge_max

func _maj_label_fusion() -> void:
	if fusion.en_fusion:
		label_fusion.text = "Fusion active — %d tour(s) restant(s)" % fusion.tours_restants
	else:
		label_fusion.text = "Fusion : %d / %d" % [fusion.jauge, fusion.jauge_max]

func _log_action_totem(decision: Dictionary) -> void:
	var cible: Combattant = decision["cible"]
	var valeur: int = decision["valeur"]
	var erratique: bool = decision["erratique"]
	var auto_d: int = decision.get("auto_degat", 0)
	match decision["action"]:
		"soin":
			if erratique and cible is Ennemi:
				_log("Le Totem tente de soigner... et soigne %s de %d PV ! (agité)" % [cible.nom_combattant, valeur])
			else:
				_log("Le Totem soigne %s de %d PV." % [cible.nom_combattant, valeur])
		"attaque":
			fusion.ajouter_points(valeur)
			if erratique and cible == joueur:
				_log("Le Totem perd le contrôle et frappe le Joueur pour %d dégâts ! (colère)" % valeur)
			elif erratique:
				_log("Le Totem oublie de soigner et attaque pour %d dégâts." % valeur)
			else:
				_log("Le Totem attaque %s pour %d dégâts." % [cible.nom_combattant, valeur])
			if auto_d > 0:
				_log("Le Totem s'inflige %d dégâts. (colère)" % auto_d)
		"esquive":
			_log("Le Totem est prêt à esquiver et à contre-attaquer.")
		"esquive_simple":
			_log("Le Totem se met sur ses gardes, prêt à esquiver.")
		"protection_egoiste":
			_log("Le Totem panique et ne pense qu'à lui — les coups seront redirigés vers toi !")
		"rien":
			_log("Le Totem hésite et ne fait rien. (anxieux)")

func _nom_palier(agitation: int) -> String:
	return totem.ia.nom_palier(agitation)

func _log(texte: String) -> void:
	journal.append_text(texte + "\n")
