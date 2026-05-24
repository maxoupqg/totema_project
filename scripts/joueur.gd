class_name Joueur
extends Combattant

@export var degats_magie: int = 25

func attaquer(cible: Combattant) -> int:
	return cible.prendre_degats(degats_base)

func defendre() -> void:
	en_defense = true

func lancer_sort(cible: Combattant) -> int:
	# Élément ignoré au proto — feu et glace auront le même effet pour l'instant
	return cible.prendre_degats(degats_magie)

func tenter_fuite() -> bool:
	return randf() >= 0.5
