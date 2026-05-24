# CLAUDE.md — Projet Jeu de Totem (proto combat)

## Contexte du projet

Prototype d'un RPG tour par tour. Le joueur combat en duo avec un **totem
semi-autonome**. Le design de référence complet est dans **`proto_combat_totem.md`**
(à la racine du projet) — le consulter avant toute décision de design ou
d'architecture. Ne pas s'en écarter sans le signaler explicitement.

**On est en Phase 0.** Objectif unique : valider que le combat en duo est fun.

## Stack technique

- **Moteur :** Godot 4.x
- **Langage :** GDScript
- **Plateforme cible :** PC (proto)

## Règle d'or — périmètre Phase 0

NE PAS implémenter, même si ça semble pertinent :
- Pas de grille, pas de pathfinding, pas de déplacement spatial.
  → Positions **abstraites** façon JRPG (combattants alignés).
- Pas de scénario, dialogues, PNJ, exploration.
- Pas de questionnaire d'intro, pas de branches d'évolution du totem.
- Pas d'assets graphiques propres → **placeholders** (carrés de couleur, formes simples).
- Un seul ennemi, un seul axe émotionnel (Calme ↔ Agité).

Si une tâche semble nécessiter un de ces éléments, **s'arrêter et demander**
avant de coder.

## Conventions GDScript

- **Typage statique systématique** : `var pv: int = 100`, `func attaquer(cible: Node) -> void:`.
- Privilégier les **signals** pour la communication entre nodes, plutôt que des
  appels directs ou des références en dur.
- Nommage : `snake_case` pour fichiers, variables et fonctions ; `PascalCase`
  pour les noms de classes et de nodes.
- Préférer `@export` pour les valeurs à équilibrer (PV, dégâts, durée de fusion)
  afin de pouvoir les régler depuis l'éditeur sans toucher au code.
- Code commenté en français, sobrement (le « pourquoi », pas le « quoi »).

## Architecture visée

Découper, ne PAS tout mettre dans un script géant :

- `combattant.gd` — classe de base commune (PV, vitesse, prendre des dégâts).
- `joueur.gd` — kit du joueur (attaque, défense, magie, fuir).
- `totem.gd` — état émotionnel + exécution de ses actions.
- `totem_ia.gd` — **logique de décision du totem isolée ici** (règles Calme/Agité).
- `ennemi.gd` — comportement de l'ennemi.
- `gestionnaire_combat.gd` — ordre des tours, déroulé du combat, condition de victoire.
- `fusion.gd` (plus tard) — jauge et forme fusionnée.

## Méthode de travail

- Construire **par couches**, dans cet ordre :
  1. Boucle de combat : joueur vs ennemi passif.
  2. Le totem et son IA (Calme/Agité, les 3 paliers).
  3. La jauge de fusion et la forme fusionnée.
- Après chaque couche : un état **jouable et testable** avant de passer à la suite.
- Faire des changements **petits et incrémentaux**. Pas de gros refactors surprise.
- En cas de doute sur le design : se référer à `proto_combat_totem.md` ou demander.

## Idées hors-scope

Toute idée d'extension qui surgit en cours de route va dans `idees_plus_tard.md`,
PAS dans le code.
