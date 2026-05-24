class_name Totem
extends Combattant

signal agitation_change(nouvelle_valeur: int)

enum TypeAxe { AGITATION, COLERE, PEUR }

@export var type_axe: TypeAxe = TypeAxe.AGITATION
@export var agitation: int = 0
@export var soin_base: int = 20
@export var agitation_par_coup: int = 20

var ia: TotemIABase
# Peur : flags activés sur le tour du totem, consommés lors des attaques ennemies
var protection_active: bool = false     # bloque un coup destiné au joueur
var protection_egoiste: bool = false    # esquive ses propres coups, redirige vers joueur

func _ready() -> void:
	match type_axe:
		TypeAxe.AGITATION: ia = TotemIAAgitation.new()
		TypeAxe.COLERE:    ia = TotemIAColere.new()
		TypeAxe.PEUR:      ia = TotemIAPeur.new()
	super._ready()

func prendre_degats(montant: int) -> int:
	var degats: int = super.prendre_degats(montant)
	_modifier_agitation(agitation_par_coup)
	return degats

func jouer_tour(joueur: Combattant, ennemi: Combattant) -> Dictionary:
	# Reset des flags de protection au début de chaque tour
	protection_active = false
	protection_egoiste = false

	var decision: Dictionary = ia.choisir_action(agitation, joueur, ennemi)
	match decision["action"]:
		"soin":
			decision["valeur"] = _soigner(decision["cible"])
		"attaque":
			var boost: float = decision.get("boost_degats", 1.0)
			decision["valeur"] = decision["cible"].prendre_degats(int(degats_base * boost))
		"protection":
			protection_active = true
		"protection_egoiste":
			protection_egoiste = true
		"rien":
			pass

	# Auto-dégât (Colère) — dégâts directs sur le totem, sans augmenter l'agitation
	var auto_d: int = decision.get("auto_degat", 0)
	if auto_d > 0:
		pv_actuels = max(0, pv_actuels - auto_d)
		queue_redraw()
		if pv_actuels <= 0:
			call_deferred("emit_signal", "mort")
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
		"%s — %d/%d PV | %d" % [nom_combattant, pv_actuels, pv_max, agitation],
		HORIZONTAL_ALIGNMENT_LEFT, -1, 12
	)
