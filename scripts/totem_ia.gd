# Axe Agitation (axe de départ du proto)
class_name TotemIAAgitation
extends TotemIABase

func nom_palier(agitation: int) -> String:
	match get_palier(agitation):
		0: return "Calme"
		1: return "Neutre"
		2: return "Agité !"
	return "?"

func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	match get_palier(agitation):
		0:	# Calme : soigne dès que le joueur a perdu des PV, sinon attaque
			if joueur.pv_actuels < joueur.pv_max:
				return _d("soin", joueur)
			return _d("attaque", ennemi)
		1:	# Neutre : 50% de chance d'oublier de soigner
			if joueur.pv_actuels < joueur.pv_max:
				if randf() < 0.5:
					return _d("soin", joueur)
				return _d("attaque", ennemi, true)  # erratique : a oublié de soigner
			return _d("attaque", ennemi)
		2:	# Agité : soigne mais cible aléatoire (peut soigner l'ennemi)
			var cible: Combattant = joueur if randf() < 0.5 else ennemi
			return _d("soin", cible, true)
	return _d("attaque", ennemi)
