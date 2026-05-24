# Axe Colère — casse la durée / les ressources (un compte à rebours)
# Calme  : attaque normale
# Nerveux: attaque boostée + auto-dégât (avertissement)
# Colère : frappe très fort + auto-dégât sérieux, peut frapper le joueur
# Fusion : les ennemis brûlent quand ils frappent le joueur
class_name TotemIAColere
extends TotemIABase

func nom_palier(agitation: int) -> String:
	match get_palier(agitation):
		0: return "Calme"
		1: return "Nerveux"
		2: return "Colère !"
	return "?"

func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	match get_palier(agitation):
		0:	# Calme : attaque normale, aucun coût
			return _d("attaque", ennemi)
		1:	# Nerveux : attaque boostée + auto-dégât faible (la colère chauffe)
			return _d("attaque", ennemi, false, 8, 1.4)
		2:	# Colère : frappe très fort, auto-dégât sérieux, 25% de frapper le joueur
			var cible: Combattant = joueur if randf() < 0.25 else ennemi
			return _d("attaque", cible, cible == joueur, 20, 2.0)
	return _d("attaque", ennemi)
