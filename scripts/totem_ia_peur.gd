# Axe Peur — casse l'esquive / la contre-attaque
# Calme    : esquive un coup qui le cible + contre-attaque automatiquement
# Méfiant  : esquive un coup qui le cible, sans contre-attaque
# Panique  : esquive TOUT ce qui le vise — mais redirige chaque coup vers le joueur
# Fusion   : esquive tout + contre-attaque sur chaque esquive
class_name TotemIAPeur
extends TotemIABase

func nom_palier(agitation: int) -> String:
	match get_palier(agitation):
		0: return "Calme"
		1: return "Méfiant"
		2: return "Panique !"
	return "?"

func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	match get_palier(agitation):
		0:	# Calme : esquive un coup + contre-attaque
			return _d("esquive", joueur)
		1:	# Méfiant : esquive un coup, mais n'ose pas contre-attaquer
			return _d("esquive_simple", joueur)
		2:	# Panique : esquive tout ce qui le vise, redirige les coups vers le joueur
			return _d("protection_egoiste", joueur, true)
	return _d("rien", joueur)
