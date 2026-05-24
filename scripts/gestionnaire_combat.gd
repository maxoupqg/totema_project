class_name GestionnaireCombat
extends Node2D

signal combat_termine(victoire: bool)

enum EtatCombat { EN_ATTENTE, TOUR_JOUEUR, TOUR_ENNEMI, TERMINE }

@onready var joueur: Joueur = $Combattants/Joueur
@onready var ennemi: Ennemi = $Combattants/Ennemi
@onready var btn_attaque: Button = $UI/PanelActions/VBoxContainer/BtnAttaque
@onready var btn_defense: Button = $UI/PanelActions/VBoxContainer/BtnDefense
@onready var btn_magie: Button = $UI/PanelActions/VBoxContainer/BtnMagie
@onready var btn_fuir: Button = $UI/PanelActions/VBoxContainer/BtnFuir
@onready var journal: RichTextLabel = $UI/JournalCombat
@onready var label_tour: Label = $UI/LabelTour

var etat: EtatCombat = EtatCombat.EN_ATTENTE

func _ready() -> void:
	joueur.mort.connect(_sur_mort_joueur)
	ennemi.mort.connect(_sur_mort_ennemi)

	btn_attaque.pressed.connect(_action_attaque)
	btn_defense.pressed.connect(_action_defense)
	btn_magie.pressed.connect(_action_magie)
	btn_fuir.pressed.connect(_action_fuir)

	_demarrer_combat()

func _demarrer_combat() -> void:
	_log("=== Combat commence ! ===")
	_debut_tour_joueur()

func _debut_tour_joueur() -> void:
	joueur.reinitialiser_tour()
	etat = EtatCombat.TOUR_JOUEUR
	_activer_boutons(true)
	label_tour.text = "Ton tour"
	_log("--- Ton tour ---")

func _activer_boutons(actif: bool) -> void:
	btn_attaque.disabled = not actif
	btn_defense.disabled = not actif
	btn_magie.disabled = not actif
	btn_fuir.disabled = not actif

func _action_attaque() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	var degats: int = joueur.attaquer(ennemi)
	_log("Tu attaques pour %d dégâts." % degats)
	_fin_tour_joueur()

func _action_defense() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	joueur.defendre()
	_log("Tu te mets en défense (dégâts réduits de moitié).")
	_fin_tour_joueur()

func _action_magie() -> void:
	if etat != EtatCombat.TOUR_JOUEUR:
		return
	_activer_boutons(false)
	var degats: int = joueur.lancer_sort(ennemi)
	_log("Tu lances un sort pour %d dégâts." % degats)
	_fin_tour_joueur()

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
		_fin_tour_joueur()

func _fin_tour_joueur() -> void:
	if not ennemi.est_vivant():
		# Mort de l'ennemi en attente (signal différé) — on n'enchaîne pas son tour
		return
	etat = EtatCombat.TOUR_ENNEMI
	label_tour.text = "Tour de l'ennemi..."
	await get_tree().create_timer(0.8).timeout
	_tour_ennemi()

func _tour_ennemi() -> void:
	_log("--- Tour de l'ennemi ---")
	var degats: int = ennemi.jouer_tour(joueur)
	_log("L'ennemi t'inflige %d dégâts%s." % [
		degats,
		" (réduit par ta défense)" if joueur.en_defense else ""
	])
	if joueur.est_vivant():
		_debut_tour_joueur()
	# Sinon : _sur_mort_joueur sera appelé en deferred à la fin du frame

func _sur_mort_joueur() -> void:
	if etat == EtatCombat.TERMINE:
		return
	etat = EtatCombat.TERMINE
	_activer_boutons(false)
	label_tour.text = "Défaite..."
	_log("=== Tu es vaincu. ===")
	emit_signal("combat_termine", false)

func _sur_mort_ennemi() -> void:
	if etat == EtatCombat.TERMINE:
		return
	etat = EtatCombat.TERMINE
	_activer_boutons(false)
	label_tour.text = "Victoire !"
	_log("=== L'ennemi est vaincu ! Victoire ! ===")
	emit_signal("combat_termine", true)

func _log(texte: String) -> void:
	journal.append_text(texte + "\n")
