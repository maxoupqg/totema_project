# Proto Combat — Jeu de Totem (nom de code à définir)

> **But de ce document :** cadrer le **prototype d'arène de combat uniquement**.
> Pas de scénario, pas d'exploration, pas de questionnaire d'intro, pas d'assets propres.
> Ce doc sert de brief à donner à Claude Code.
>
> **Question unique à laquelle le proto doit répondre :**
> *« Est-ce que c'est fun d'agir en duo, à tour de rôle, avec un totem semi-autonome ? »*
>
> Tout le contenu de ce proto est **jetable**. Placeholders (carrés de couleur) uniquement.

---

## 0. Approche en 2 phases

Le proto se construit en deux temps pour limiter les risques.

**Phase 0 — Combat abstrait (à faire EN PREMIER)**
Positions abstraites façon JRPG : combattants alignés, pas de déplacement spatial,
pas de grille. On valide uniquement la boucle de combat et le fun du duo.

**Phase 1 — Grille tactique (seulement si Phase 0 est fun)**
Ajout d'une grille façon FFT / Fire Emblem / Dofus : déplacement, portées, pathfinding.
> ⚠️ La grille double facilement le temps de dev (pathfinding, portées, IA de
> déplacement, caméra). Ne PAS l'attaquer tant que la Phase 0 n'a pas prouvé que
> le combat est fun. Un combat chiant sur une ligne sera chiant sur une grille.

---

## 1. Les combattants

Trois entités dans l'arène :

- **Le Joueur** — contrôlé entièrement par le joueur.
- **Le Totem** — allié du joueur, **semi-autonome** (voir §4).
- **L'Ennemi** — un seul ennemi pour le proto.

---

## 2. Structure du tour

- **Ordre des tours : à l'initiative.** Une stat de **Vitesse** par combattant
  détermine l'ordre de jeu. (Pour la Phase 0, on peut commencer avec un ordre
  fixe Joueur → Totem → Ennemi pour simplifier, puis brancher l'initiative.)
- **À son tour, chaque personnage peut : 1 déplacement + 1 action.**
  - Phase 0 : le déplacement est ignoré (positions abstraites).
  - Phase 1 : le déplacement utilise la grille.
- L'action est unique : attaquer **OU** lancer un sort **OU** défendre **OU** fuir.

---

## 3. Kit du Joueur

Actions disponibles au tour du joueur (heroic fantasy classique, volontairement
minimal pour le proto) :

| Action   | Effet (proto) |
|----------|---------------|
| Attaque  | Dégâts physiques sur une cible. |
| Défense  | Réduit les dégâts reçus jusqu'au prochain tour. |
| Magie    | Sort élémentaire (feu / glace pour le proto — 2 suffisent). |
| Fuir     | Tentative de sortie de combat. |

> Pour le proto, garder ces 4 actions. Ne pas ajouter de compétences avant que
> la boucle de base soit validée.

---

## 4. Le Totem — comportement semi-autonome

Le totem agit **seul à son tour**, selon des règles **lisibles** (pas d'aléatoire
pur). Le joueur ne contrôle pas ses actions : il doit apprendre ses patterns et
composer avec. C'est le cœur du jeu — le totem doit pouvoir « faire chier » de
façon compréhensible, jamais par un coup de dé injuste.

### Axe émotionnel du proto : Calme ↔ Agité

Un seul axe pour le proto. Une valeur numérique (ex. 0 = totalement Calme,
100 = totalement Agité), découpée en 3 paliers.

| Palier  | Comportement du totem |
|---------|------------------------|
| **Calme** | Défend et soigne le joueur de façon fiable. |
| **Neutre** | Comportement intermédiaire (soigne moins, agit prudemment). |
| **Agité** | Devient maladroit : ses soins peuvent toucher la mauvaise cible (ex. soigne l'ennemi), ses actions deviennent erratiques. |

### Ce qui déplace le totem sur l'axe

- **Se prendre des coups → le totem s'agite.** (Mécanique de base du proto.)
- *(À explorer plus tard : les choix du joueur, les actions en combat, etc.)*

### Règles de décision (à formaliser avec Claude Code)

Le totem choisit son action via une petite logique de type « if / else » lisible.
À écrire explicitement au moment du code, ex. :
> « Si Calme et joueur sous 50% PV → soigne le joueur.
>   Si Agité → action de soin mais cible choisie de façon erratique. »

---

## 5. La Fusion

### Jauge de fusion
- La jauge **monte à chaque ennemi tué**.
  > 💡 **Point de design à trancher (voir note ci-dessous).** Pour le proto on
  > garde « monte en tuant », mais réfléchir à une alternative côté thème.

### Forme fusionnée — la fusion-accord
- Quand la jauge est pleine, le joueur peut **fusionner avec le totem** pour
  **X tours** (X à définir et tester — commencer à 3).
- **Principe :** pendant la fusion, le totem ne disparaît pas et ne se tait pas.
  Il **double chaque action du joueur avec la version idéale de son émotion**,
  automatiquement et sans aléatoire.
  > Exemple sur l'axe Calme/Agité : chaque attaque du joueur déclenche
  > **simultanément un soin fiable et amplifié** (la « meilleure version » du
  > soin — jamais sur la mauvaise cible, contrairement au totem agité).
- Effet global : **plus de puissance** + cet **effet de synergie gratuit sur
  chaque action**. Le joueur garde le contrôle ; le totem agit *avec* lui au
  lieu d'agir *contre* son plan.

> **Pourquoi cette version :** le message mécanique devient juste — la maîtrise
> n'est pas de *faire taire* l'émotion mais d'atteindre l'état où elle te
> *soutient*. Le filigrane (apprivoiser, pas museler) tient.

> **Définition réutilisable :** « la meilleure version de l'axe » donne un
> gabarit clair. Chaque futur axe émotionnel aura naturellement sa propre
> forme fusionnée idéale.

### ⚠️ Garde-fou d'équilibrage (à surveiller aux tests, pas maintenant)
La fusion cumule puissance accrue + effet gratuit par action + zéro aléatoire.
Risque : qu'elle soit si écrasante que le **duo imparfait** (le cœur du jeu)
devienne « le truc chiant qu'on subit en attendant la fusion ».
→ La fusion doit rester un **pic court**, pas la norme. Ne pas la rendre trop
forte ni trop longue. À calibrer au moment des tests.

---

## 6. Hors-scope du proto (NE PAS faire maintenant)

- Scénario, dialogues, PNJ, zones d'exploration.
- Questionnaire d'intro qui génère le totem.
- Système de branches d'évolution du totem.
- Table de correspondance complète émotions ↔ stats (voir §7, amorce seulement).
- Assets graphiques propres — **placeholders uniquement**.
- Plusieurs ennemis, plusieurs axes émotionnels.

---

## 7. Amorce — table émotions / stats (POUR PLUS TARD, pas le proto)

Note pour la version complète : prévoir **2-3 axes émotionnels maximum**,
chacun avec peu de paliers, pour éviter l'explosion combinatoire.
Idée d'axes possibles : « gestion du conflit », « gestion de la peur ».
À développer une fois le combat validé. **Ne rien coder de ça pour le proto.**

---

## 8. Definition of Done — le proto est « fini » quand…

- [ ] Un combat complet se joue : Joueur + Totem vs 1 Ennemi.
- [ ] L'ordre des tours fonctionne (fixe puis initiative).
- [ ] Les 4 actions du joueur fonctionnent.
- [ ] Le totem agit seul selon l'axe Calme/Agité et ses 3 paliers.
- [ ] Se prendre des coups agite visiblement le totem.
- [ ] La jauge de fusion se remplit et la forme fusionnée est jouable.
- [ ] **Tu peux répondre honnêtement : est-ce que c'était fun ?**

> Si oui → on greffe la grille (Phase 1), puis le reste du RPG.
> Si non → on l'a découvert en 2 semaines, pas en 6 mois. C'est une victoire.
