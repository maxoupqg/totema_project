class_name TotemIABase
extends RefCounted

const SEUIL_NEUTRE: int = 34
const SEUIL_EXTREME: int = 67

func get_palier(agitation: int) -> int:
	# 0 = calme, 1 = neutre, 2 = extrême
	if agitation < SEUIL_NEUTRE:
		return 0
	elif agitation < SEUIL_EXTREME:
		return 1
	return 2

# À surcharger dans chaque axe
func nom_palier(agitation: int) -> String:
	return "?"

# Format du dictionnaire retourné :
# { action, cible, valeur(=0), erratique, auto_degat(=0), boost_degats(=1.0) }
# - action   : "soin" | "attaque" | "protection" | "protection_egoiste" | "rien"
# - auto_degat : dégâts que le totem s'inflige lui-même (Colère)
# - boost_degats : multiplicateur sur degats_base du totem
func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	return _d("attaque", ennemi)

# Helper interne pour construire le dictionnaire
func _d(action: String, cible: Combattant, erratique: bool = false,
		auto_degat: int = 0, boost: float = 1.0) -> Dictionary:
	return {
		"action": action, "cible": cible, "valeur": 0,
		"erratique": erratique, "auto_degat": auto_degat, "boost_degats": boost
	}
