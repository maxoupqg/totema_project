class_name Totem
extends Combattant

signal agitation_change(nouvelle_valeur: int)

@export var agitation: int = 0
@export var soin_base: int = 20
@export var agitation_par_coup: int = 20

func prendre_degats(montant: int) -> int:
	var degats: int = super.prendre_degats(montant)
	# Se prendre des coups agite le totem
	_modifier_agitation(agitation_par_coup)
	return degats

func jouer_tour(joueur: Combattant, ennemi: Combattant) -> Dictionary:
	var decision: Dictionary = TotemIA.choisir_action(agitation, joueur, ennemi)
	match decision["action"]:
		"soin":
			decision["valeur"] = _soigner(decision["cible"])
		"attaque":
			decision["valeur"] = decision["cible"].prendre_degats(degats_base)
	return decision

func _soigner(cible: Combattant) -> int:
	var soin_reel: int = min(soin_base, cible.pv_max - cible.pv_actuels)
	cible.pv_actuels += soin_reel
	cible.queue_redraw()
	return soin_reel

func _modifier_agitation(delta: int) -> void:
	agitation = clamp(agitation + delta, 0, 100)
	emit_signal("agitation_change", agitation)
	queue_redraw()

func _draw() -> void:
	var ratio_agit: float = float(agitation) / 100.0
	# Couleur qui glisse du calme vers l'agité
	var couleur_agit: Color = couleur.lerp(Color(0.9, 0.35, 0.1, 1), ratio_agit)
	draw_rect(Rect2(-40.0, -40.0, 80.0, 80.0), couleur_agit)
	draw_rect(Rect2(-40.0, -40.0, 80.0, 80.0), Color.WHITE, false, 2.0)
	# Barre de vie
	var ratio_pv: float = float(pv_actuels) / float(pv_max)
	draw_rect(Rect2(-40.0, 48.0, 80.0, 8.0), Color(0.35, 0.0, 0.0))
	draw_rect(Rect2(-40.0, 48.0, 80.0 * ratio_pv, 8.0), Color(0.1, 0.75, 0.1))
	# Barre d'agitation
	draw_rect(Rect2(-40.0, 60.0, 80.0, 6.0), Color(0.2, 0.2, 0.2))
	draw_rect(Rect2(-40.0, 60.0, 80.0 * ratio_agit, 6.0),
		Color(0.9, 0.7, 0.1).lerp(Color(0.9, 0.2, 0.1), ratio_agit))
	# Texte
	draw_string(
		ThemeDB.fallback_font,
		Vector2(-40.0, 88.0),
		"%s — %d/%d PV | Agit: %d" % [nom_combattant, pv_actuels, pv_max, agitation],
		HORIZONTAL_ALIGNMENT_LEFT, -1, 12
	)
