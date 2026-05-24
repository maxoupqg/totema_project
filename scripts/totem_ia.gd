class_name TotemIA
extends RefCounted

enum Palier { CALME, NEUTRE, AGITE }

const SEUIL_NEUTRE: int = 34
const SEUIL_AGITE: int = 67

static func get_palier(agitation: int) -> Palier:
	if agitation < SEUIL_NEUTRE:
		return Palier.CALME
	elif agitation < SEUIL_AGITE:
		return Palier.NEUTRE
	else:
		return Palier.AGITE

# Retourne { action, cible, valeur (rempli par Totem), erratique }
static func choisir_action(agitation: int, joueur: Combattant, ennemi: Combattant) -> Dictionary:
	match get_palier(agitation):
		Palier.CALME:
			# Support fiable : soigne dès que le joueur a perdu des PV, sinon attaque
			if joueur.pv_actuels < joueur.pv_max:
				return { "action": "soin", "cible": joueur, "valeur": 0, "erratique": false }
			return { "action": "attaque", "cible": ennemi, "valeur": 0, "erratique": false }
		Palier.NEUTRE:
			# Distrait : 50% de chance d'oublier de soigner et d'attaquer à la place
			if joueur.pv_actuels < joueur.pv_max:
				if randf() < 0.5:
					return { "action": "soin", "cible": joueur, "valeur": 0, "erratique": false }
				else:
					return { "action": "attaque", "cible": ennemi, "valeur": 0, "erratique": true }
			return { "action": "attaque", "cible": ennemi, "valeur": 0, "erratique": false }
		Palier.AGITE:
			# Tente de soigner mais cible aléatoire — peut soigner l'ennemi
			var cible_soin: Combattant = joueur if randf() < 0.5 else ennemi
			return { "action": "soin", "cible": cible_soin, "valeur": 0, "erratique": true }
	return { "action": "attaque", "cible": ennemi, "valeur": 0, "erratique": false }
