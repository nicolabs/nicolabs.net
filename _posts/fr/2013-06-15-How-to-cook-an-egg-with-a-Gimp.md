---
layout: post
title: "Comment préparer un oeuf avec Gimp"
date: 2013-06-15 12:44:22 +0100
permalink: fr/articles/un-oeuf-avec-gimp
tags:
  - absync
  - gimp
  - graphism
---

![L'oeuf évolue !](/assets/blog/egg-evolution_0.png)

Voici un petit guide pour dessiner un oeuf avec [Gimp](http://www.gimp.org/).

Les techniques décrites ici permettent à la fois de dessiner un oeuf réaliste pour les boulots sérieux **(!)** et un oeuf type "bande dessinée", typiquement à usage de gamification **;-)**

Vous trouverez le fichier Gimp complet en pièce jointe, que je vous invite à réutiliser ou à prendre comme source d'inspiration.

> Etant un utilisateur occasionnel de Gimp, je ne garantis pas que les méthodes décrites dans cet article soient les plus appropriées.
> En particulier, si vous cherchez à créer rapidement un oeuf plaqué d'une texture de votre choix, le tutoriel suivant devrait mieux vous satisfaire : [gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp](http://www.gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp/)


## La forme

La première étape consiste à dessiner le contour de l'oeuf.

Il existe différentes approches :

- Reprendre un modèle existant (c'est la méthode que j'ai utilisée : [elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html](http://elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html))
- Utiliser un plug-in dédié (ex : [gimpchat.com/viewtopic.php?f=9&t=7038](http://www.gimpchat.com/viewtopic.php?f=9&t=7038))
- Manipuler l'outil Ellipse en combinaison avec d'autres (non testé)
- Utiliser directement l'outil Sphere designer (non testé)
- ...

Il s'agit de l'étape la plus importante car tout le reste est basé sur ce calque.
Assurez-vous donc d'avoir la forme qui vous convient avant d'enchaîner les étapes suivantes : vérifiez notamment que la résolution est suffisante.

Si vous avez besoin d'une résolution élevée, je vous conseille de redessiner la forme dans une image différente de celle fournie avec cet article ; vous pourriez entre autres utiliser le plug-in évoqué ci-dessus.
Pour dessiner une icône d'application Android par exemple, [une résolution de 864x864 est recommandée](https://developer.android.com/guide/practices/ui_guidelines/icon_design.html#design-tips).

![L'oeuf prend forme...](/assets/blog/shape.png)


## Le volume

Le principe général pour créer une impression de volume est d'appliquer un dégradé (et oui tout n'est qu'impression dans le dessin !).

> Cette partie du guide est probablement celle qui mérite le plus d'être améliorée, car elle a notamment un effet de bord non désiré : elle ternit les couleurs au lieu de seulement les assombrir. Une piste intéressante est l'outil "Sphere designer", qui permet d'appliquer un éclairage réaliste très simplement (voir le lien à la fin de cet article).


### Les bords

Pour créer un effet de volume, nous allons tout d'abord sélectionner la forme de l'oeuf dessinée précédemment et appliquer le filtre _"Ombre et Lumière > Ombre portée"_, avec un décalage nul (x=0, y=0).
Cela fait ressortir l'arrondi des bords de l'oeuf.

![L'oeuf est PLUS qu'une surface...](/assets/blog/pictures/edges.png)


### La surface

Afin de suggérer la forme rebondie de l'oeuf, nous allons ajouter un nouveau dégradé, réalisé cette fois selon une autre technique.
Il s'agit de créer un effet de lumière, puis de le transformer en assombrissement.

Pour cela, sélectionner le filtre _"Light and Shadow > Lighting Effects"_ et ajuster les paramètres en fonction de l'aspect voulu. L'aperçu intégré dans ce plug-in est très utile.
Pour ma part j'ai aligné la source de lumière sur le centre de l'oeuf et ajusté les paramètres de telle manière qu'ils produisent une lumière diffuse s'estompant rapidement sur les bords de l'oeuf.

Une fois l'effet de lumière appliqué, choisir le menu _"Couleur > Couleur vers Alpha"_ et sélectionner la couleur de la lumière (le blanc habituellement) : l'image devient alors un calque alpha donnant une impression de volume.

![L'oeuf est lisse...](/assets/blog/pictures/lighting-shadow.png)


## L'éclairage

Pour donner une apparence réaliste, nous allons ajouter un éclairage diffus avec l'outil _"Light and Shadow > Lighting Effects"_.
Il est possible d'appliquer plusieurs sources de lumière en fonction de la scène dans laquelle l'oeuf sera présenté. Si l'oeuf est blanc, utiliser une autre couleur d'éclairage.

Afin de renforcer l'aspect lisse et brillant de la coquille, nous pouvons ajouter un reflet simplement composé d'un ovale blanc rendu semi-transparent.

![L'oeuf est dans la place...](/assets/blog/pictures/lighting.png)


## L'effet B.D.

En général on peut donner un effet "bande dessinée" à un dessin en accentuant les traits.

Dans le cas de notre oeuf, la première chose à faire consiste à augmenter l'épaisseur du contour, ce qui est très facilement réalisé par le menu _Sélection > Bordure"_.

Il est également possible d'accentuer les dégradés en jouant sur le taux de transparence et d'intensifier les couleurs pour les faire ressortir.

![L'oeuf est dessiné...](/assets/blog/pictures/cartoon.png)

Lors du redimensionnement de l'image vers une taille plus petite, ne pas utiliser de lissage, afin d'obtenir un contour net sur un fond transparent.


## La texture

L'une des raisons pour laquelle je me suis lancé dans cette entreprise était de pouvoir fabriquer une série d'oeufs décorés de manière originale pour différentes occasions.

Une méthode pour plaquer une texture sur l'oeuf est d'exploiter le plug-in _"Filters > [G'MIC](http://gmic.sourceforge.net/) > Deformations > Fish-eye"_.

On peut obtenir facilement l'effet attendu en appliquant ce filtre à un calque contenant la texture.
Bien que cet effet ne déforme pas l'image exactement selon la forme d'un oeuf, la différence n'est pas notable à l'oeil nu.

![L'oeuf est bien habillé...](/assets/blog/pictures/texture.png)


## Réutilisation

Voilà pour les quelques conseils ; j'autorise (et j'encourage) quiconque à réutiliser cette image, et à la modifier pour usage personnel ou commercial.

Tirez profit de l'image source au format Gimp jointe à cet article et n'hésitez pas à me remonter vos commentaires, je serais très heureux d'avoir vos retours !

![L'oeuf est libre...](/assets/blog/pictures/egg-real.png)![L'oeuf est libre...](/assets/blog/pictures/egg-cartoon.png)

_Télécharger le fichier source : [egg.xcf](/assets/blog/egg.xcf)_


## Références

- Gimp - [gimp.org](http://www.gimp.org/)
- Plug-in "oeuf" - [gimpchat.com/viewtopic.php?f=9&t=7038](http://www.gimpchat.com/viewtopic.php?f=9&t=7038)
- Plug-in G'MIC - [gmic.sourceforge.net](http://gmic.sourceforge.net/)
- Android Icon Design Guidelines - [developer.android.com/guide/practices/ui_guidelines/icon_design.html](https://developer.android.com/guide/practices/ui_guidelines/icon_design.html)
- Tutoriels en français et modèle de forme - [elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html](http://elledemai.blogspot.fr/2009/03/tutoriel-uf-et-cu-happy-eggs.html)
- Icônes d'oeuf - [softicons.com/search?search=egg](http://www.softicons.com/search?search=egg)
- Tutoriel vidéo - [youtube.com/watch?v=0c-hMz2XpP8](https://www.youtube.com/watch?v=0c-hMz2XpP8)
- Super guide pour plaquer une texture - [gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp](http://www.gimptalk.com/index.php?/topic/1659-making-empty-broken-egg-shell-in-gimp/)
