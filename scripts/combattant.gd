class_name Combattant
extends Node2D

signal pv_change(nouveau_pv: int, max_pv: int)
signal mort

@export var nom_combattant: String = "Combattant"
@export var pv_max: int = 100
@export var vitesse: int = 10
@export var degats_base: int = 15
@export var couleur: Color = Color(0.5, 0.5, 0.5, 1)

var pv_actuels: int
var en_defense: bool = false

func _ready() -> void:
	pv_actuels = pv_max
	queue_redraw()

func _draw() -> void:
	# Placeholder visuel : carré coloré
	draw_rect(Rect2(-40.0, -40.0, 80.0, 80.0), couleur)
	draw_rect(Rect2(-40.0, -40.0, 80.0, 80.0), Color.WHITE, false, 2.0)
	# Barre de vie
	var ratio: float = float(pv_actuels) / float(pv_max)
	draw_rect(Rect2(-40.0, 48.0, 80.0, 8.0), Color(0.35, 0.0, 0.0))
	draw_rect(Rect2(-40.0, 48.0, 80.0 * ratio, 8.0), Color(0.1, 0.75, 0.1))
	# Texte nom + PV
	draw_string(
		ThemeDB.fallback_font,
		Vector2(-40.0, 78.0),
		"%s — %d/%d PV" % [nom_combattant, pv_actuels, pv_max],
		HORIZONTAL_ALIGNMENT_LEFT, -1, 13
	)

func prendre_degats(montant: int) -> int:
	var degats_reels: int = montant / 2 if en_defense else montant
	pv_actuels = max(0, pv_actuels - degats_reels)
	queue_redraw()
	emit_signal("pv_change", pv_actuels, pv_max)
	if pv_actuels <= 0:
		# Différé pour éviter la ré-entrance dans la logique de combat
		call_deferred("emit_signal", "mort")
	return degats_reels

func reinitialiser_tour() -> void:
	en_defense = false

func est_vivant() -> bool:
	return pv_actuels > 0
