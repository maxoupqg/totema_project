class_name Ennemi
extends Combattant

# 0.0 = cible aléatoire, 1.0 = cible toujours le totem si vivant
@export var preference_totem: float = 0.0

func jouer_tour(cible: Combattant) -> int:
	return cible.prendre_degats(degats_base)
