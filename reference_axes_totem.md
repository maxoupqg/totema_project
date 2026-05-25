# Référence des Axes — Jeu de Totem

> **But de ce document :** définir les **axes émotionnels** du totem.
> Sert de référence de design et de brief pour Claude Code.
> Complète `proto_combat_totem.md` (boucle de combat) — ne pas le remplacer.

---

## Rappel du modèle

- Le joueur a **un seul totem**, le sien, pour toute la partie. Il n'est pas
  invocable, il ne se collectionne pas — il **évolue avec le joueur**.
- À un instant donné, le totem est sur **un seul axe émotionnel à la fois**.
- Le questionnaire d'intro pose le totem sur son axe de départ. *(Hors-scope
  pour l'instant — voir §Hors-scope.)*
- En jouant, des jauges invisibles se remplissent. À chaque palier d'évolution,
  le totem **bascule sur un nouvel axe**. L'enchaînement des axes forme un
  arbre d'évolution. *(Arbre = hors-scope pour l'instant.)*

### Règle de nommage — IMPORTANT
Le joueur ne doit **jamais** voir le mot « émotion » ni les noms d'émotions.
Pour lui, c'est **son compagnon**, avec sa propre identité.
→ Dans le **code et les docs de design** : on parle librement d'émotions
  (Agitation, Colère, Peur) — c'est l'outil de pensée.
→ Dans le **jeu visible** (UI, textes, noms) : uniquement une identité de
  compagnon, jamais l'émotion.

### Règle de cohérence des axes
Sur chaque axe : le pôle **« calme » = l'état maîtrisé / fiable**.
Le **pôle opposé = l'état puissant ou extrême, mais risqué / problématique**.
Tout nouvel axe doit respecter cette lecture.

### Principe de la Fusion
La fusion = l'émotion dans sa **version idéale et maîtrisée**.
Elle doit **répondre au problème de son propre axe** (pas juste « plus fort »).
Pas d'aléatoire en fusion : c'est le moment où le joueur contrôle.

### Principe de variété des axes
Chaque axe doit **casser quelque chose de différent** en combat.
Ne jamais créer deux axes qui produisent le même ressenti.

---

## Axe 1 — Agitation

**Ce qu'il casse :** le **ciblage du soin** (l'incertitude).

| Palier | Comportement |
|--------|--------------|
| Calme  | Soigne le joueur de façon fiable. |
| Neutre | Oublie de soigner par moment (imprévisible). |
| Agité  | Soigne à chaque tour, mais la cible est aléatoire — peut soigner l'ennemi. |

**Fusion :** soin fiable et **amplifié**, jamais sur la mauvaise cible.

---

## Axe 2 — Colère

**Ce qu'il casse :** la **durée / les ressources** (un compte à rebours).

| Palier | Comportement |
|--------|--------------|
| Calme  | Attaque normale, aucun coût. |
| Neutre | La colère monte : attaque (un peu plus fort) + **auto-dégât faible**. C'est l'avertissement, le joueur sent que ça chauffe. |
| Colère | Tape fort, **auto-dégât proportionnel sérieux**, peut frapper le joueur. |

**Fusion :** les ennemis **se blessent en attaquant** le joueur (l'auto-destruction
de l'axe est retournée contre l'adversaire).

---

## Axe 3 — Peur

**Ce qu'il casse :** l'**esquive / contre attaque** .

| Palier | Comportement |
|--------|--------------|
| Calme  | Esquive automatiquement un coup qui cible le totem par tour et contre attaque automatiquement. |
| Neutre | Esquive juste les coups sans contre attaque |
| Palier 3 | Esquive **tout ce qui le vise**, mais pour se sauver lui — chaque coup esquivé est **redirigé en dégâts sur le joueur**. |

**Fusion :** esquive tout + **contre-attaque déclenchée sur chaque esquive**
(la peur maîtrisée transforme chaque danger en opportunité).

> ⚠️ **Note d'implémentation (pour plus tard, pas maintenant) :** au palier 3,
> la redirection de dégâts vers le joueur doit être **très lisible à l'écran**
> (effet visuel reliant totem et joueur), sinon le joueur la vivra comme un
> coup injuste ou un bug.

---

## Prochaine étape de dev — Test de variété

Objectif : vérifier que **plusieurs axes pris séparément sont fun en combat**,
avant de concevoir l'arbre d'évolution.

À faire :
- Implémenter les axes Colère et Peur (l'Agitation est déjà au proto).
- Pouvoir lancer un combat avec le totem réglé sur l'un ou l'autre axe.
- Enchaîner **3-4 combats** d'affilée pour sentir si la tension tient sur la durée.
- Idéalement, un **2e type d'ennemi** qui interagit autrement avec l'axe.

> Toujours en placeholders. Pas d'assets propres.

---

## Hors-scope (NE PAS faire maintenant)

- Le **questionnaire d'intro** qui génère le totem de départ.
- L'**arbre d'évolution** (jauges invisibles, basculement d'axe aux paliers).
- La grille tactique (voir `proto_combat_totem.md`, Phase 1).
- Le scénario, l'exploration, les assets propres.
- Tout nouvel axe au-delà des 3 définis ici.

---

## Idées à garder pour plus tard (→ `idees_plus_tard.md`)

- **Axe « visée / confusion »** : un totem qui « attaque sans regarder », faible
  chance de toucher. Écarté de la Peur car offensif, pas défensif — mérite son
  propre axe.
- Axes possibles à explorer ensuite : un axe jouant sur l'**ordre des tours /
  la vitesse**, un axe jouant sur l'**information** (le totem agit avant que le
  joueur choisisse), un axe verrouillant certaines **options d'action**.
