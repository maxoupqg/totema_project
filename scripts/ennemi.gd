class_name Ennemi
extends Combattant

func jouer_tour(cible: Combattant) -> int:
	return cible.prendre_degats(degats_base)
