# Axe Peur — casse l'esquive / la protection (pour qui le totem se protège)
# Calme      : se positionne pour bloquer un coup destiné au joueur
# Anxieux    : oublie de protéger une fois sur deux
# Panique    : esquive tout ce qui le vise — mais redirige les coups vers le joueur
# Fusion     : intercepte + contre-attaque sur chaque frappe ennemie
class_name TotemIAPeur
extends TotemIABase

func nom_palier(agitation: int) -> String:
	match get_palier(agitation):
		0: return "Calme"
		1: return "Anxieux"
		2: return "Panique !"
	return "?"

func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	match get_palier(agitation):
		0:	# Calme : protection fiable du joueur
			return _d("protection", joueur)
		1:	# Anxieux : 50% de chance d'oublier de se positionner
			if randf() < 0.5:
				return _d("protection", joueur)
			return _d("rien", joueur, true)  # erratique : a oublié de protéger
		2:	# Panique : protection égoïste (se protège lui, redirige vers joueur)
			return _d("protection_egoiste", joueur, true)
	return _d("rien", joueur)
