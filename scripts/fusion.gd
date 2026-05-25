class_name Fusion
extends Node

signal jauge_change(valeur: int, max_val: int)
signal fusion_activee
signal fusion_terminee

@export var jauge_max: int = 150
@export var duree_fusion: int = 3
@export var soin_fusion: int = 40

var jauge: int = 0
var en_fusion: bool = false
var tours_restants: int = 0

func reduire_jauge(fraction: float) -> void:
	jauge = max(0, int(jauge * (1.0 - fraction)))
	emit_signal("jauge_change", jauge, jauge_max)

func ajouter_points(degats: int) -> void:
	if en_fusion or jauge >= jauge_max:
		return
	jauge = min(jauge + degats, jauge_max)
	emit_signal("jauge_change", jauge, jauge_max)

func activer() -> void:
	en_fusion = true
	tours_restants = duree_fusion
	jauge = 0
	emit_signal("jauge_change", jauge, jauge_max)
	emit_signal("fusion_activee")

func decrementer_tour() -> void:
	if not en_fusion:
		return
	tours_restants -= 1
	if tours_restants <= 0:
		en_fusion = false
		emit_signal("fusion_terminee")
