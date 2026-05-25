# Idées plus tard — Jeu de Totem

> Dépôt des idées qui dépassent le périmètre actuel. **Rien ici ne se code
> maintenant.** On note pour ne pas perdre, puis on revient au combat.
> L'étape en cours est toujours : Peur option B → test de variété.

---

## Architecture modulaire des comportements de totem
Transformer les comportements (attaque, soin, esquive, auto-dégât, redirection…)
en **modules réutilisables** qui s'assemblent, se cumulent, se mélangent — utile
pour les axes futurs plus complexes.
**Quand :** en passe de refacto, APRÈS le test de variété, en regardant les 3
axes déjà codés côte à côte. Jamais avant — abstraction prématurée sinon.

---

## Axe « visée / confusion »
Un totem qui « attaque sans regarder », faible chance de toucher l'ennemi.
Écarté de l'axe Peur (offensif, pas défensif) — mérite son propre axe.

## Autres axes émotionnels à explorer
- Un axe jouant sur l'**ordre des tours / la vitesse**.
- Un axe jouant sur l'**information** (le totem agit avant que le joueur choisisse).
- Un axe verrouillant certaines **options d'action** du joueur.

---

## Variation visuelle procédurale (mécanique faite main)
Idée : la « peur » d'un joueur ne ressemble pas visuellement à celle d'un autre.
→ Le procédural s'applique **uniquement au visuel** : apparence du totem,
couleur, silhouette, détails — paramétrés / variables d'un joueur à l'autre.
→ La **mécanique reste 100% faite main** : l'axe Peur (ses 3 paliers, son
problème de combat, sa fusion) est identique pour tous. Deux joueurs sur l'axe
Peur jouent la même mécanique, mais leur compagnon a une autre tête.

**Pourquoi c'est sain :** habiller un axe ne touche pas au filigrane — ça
renforce même le « c'est MON compagnon ». À ne PAS confondre avec du procédural
appliqué à la mécanique (générer comportements/stats/règles) → ça, c'est le
piège, voir le système du carnet ci-dessous.

**Quand :** dernière couche. La variation visuelle habille des axes — on ne peut
pas habiller ce qui n'existe pas encore. Donc APRÈS que les axes soient conçus
et validés en jeu.

---

## Système de totems « par collection » — du vieux carnet (ÉCARTÉ)
Le carnet décrivait les totems comme une grande collection à générer :
arbre de catégories (cat 1 à 10), puis un système éléments × physique ×
alignement avec pourcentages.
- Première version : aboutissait à **6128** totems (noté « énorme » par Maxou
  lui-même).
- Version « réduite » : aboutissait quand même à **450 totems + colorisations
  infinies**.
**Statut : écarté.** Remplacé par le modèle actuel — **un seul totem, un seul
axe à la fois, qui évolue**. Plus malin, plus petit, faisable en solo.
À ne reconsidérer QUE si le modèle actuel échoue au test — ce qui est peu probable.

---

## Idées diverses du carnet à reconsidérer plus tard
- Gameplay console **et** smartphone (le carnet pose les deux).
- Interfaces : exploration, combat, menus/paramètres.
- Financement : perso ou Kickstarter (très loin — ne pas y penser maintenant).
- Système de niveau : XP perso, et la question « le totem level-up avec le perso
  ou indépendamment ? » + « niveau de symbiose ». Délicat : la progression RPG
  classique (XP) peut entrer en conflit avec l'évolution émotionnelle du totem.
  À trancher quand le combat et l'évolution seront posés.
