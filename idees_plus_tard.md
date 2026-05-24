# Idées pour plus tard — hors scope proto

> Ce fichier sert à capturer les idées qui émergent en cours de route.
> Rien ici ne va dans le code tant que la phase en cours n'est pas validée.

---

## Axes émotionnels supplémentaires

Le proto valide l'axe **Calme ↔ Agité** (support/soin).
Chaque nouvel axe = un nouveau `totem_ia_XXX.gd` + une nouvelle forme fusionnée.

Axes envisagés :
- **Colère** : attaque fort mais peut frapper le joueur en cas d'agitation
- **Joie** : boost d'actions alliées mais distrait, ignore les menaces
- **Tristesse** : défense/protection mais peut se paralyser sous pression
- **Peur** : fuite / esquive mais peut abandonner le combat
- *(max 2-3 axes actifs simultanément pour éviter l'explosion combinatoire)*

Chaque axe a sa propre "version idéale" en fusion — le gabarit est déjà posé.

---

## Évolution du totem selon les actions du joueur

Le totem évolue différemment selon comment le joueur se comporte en combat :
- Jouer agressif → oriente vers Colère
- Jouer défensif → oriente vers Calme ou Peur
- Actions altruistes / protéger le totem → oriente vers Joie ou Confiance
- Subir beaucoup sans réagir → oriente vers Tristesse

Mécanisme à concevoir : quel déclencheur, quelle durée, réversible ou permanent ?

---

## Phase 1 — Grille tactique

(Seulement si Phase 0 est fun — **c'est le cas**.)
- Grille façon FFT / Fire Emblem / Dofus
- Déplacement, portées, pathfinding
- IA de déplacement pour les ennemis
- Attention : double le temps de dev minimum

---

## Questionnaire d'intro

Génère le type de totem initial selon les réponses du joueur.
À faire après que les axes émotionnels soient stables.

---

## Plusieurs ennemis avec comportements variés

- Ennemis qui ciblent préférentiellement le totem (pour l'agiter)
- Ennemis avec leur propre "état émotionnel"
- Boss avec phases

---

## Jauge de fusion — variante de remplissage

La jauge "monte en tuant" (doc original) vs "monte en infligeant des dégâts" (proto actuel).
À tester : est-ce que le rythme feel right sur plusieurs combats ?
