---
layout: post
title: Un retour d'expérience sur les traces applicatives
date: 2013-03-07 14:03:41 +0100
tags:
  - java
  - logging
  - monitoring
  - security
  - testing
---
## Draft !

# Sémantiquement

Événements destinés au développeur ou à l'exploitant.

Habituellement les évènements sont des "messages", composés de méta données (ex. En tête) et de champs de données. Une ligne de log contient également des méta données (timestamp, niveau de verbosité, nom du logger, ...) Et généralement un seul champ : le contenu que le développeur a écrit).

On pourrait donc utiliser la même API ou le même framework pour tout type d'événement, y compris des logs.

Toutefois en termes de mise en place il est plus simple/direct d'implémenter des logs qu'un système d'événements, les 2 ont donc leur place.

Il manque peu pour pouvoir uniformiser les 2 :
- API suffisamment fluide pour les différents types d'événements (méthodes/fonctions adaptées)
- API assez puissante pour ne pas restreindre les usages actuels (ex. Topics/tags pour les évènements, niveaux de verbosité pour les logs*)
- performances non pénalisées par un mode (traces et envois asynchrones)
- connecteurs pour différents types de récolte (fichiers locaux, serveur distant, ...)

* On peut donc imaginer profiter de tags dans les logs pour pouvoir les filtrer facilement (les marqueurs slf4j ne sont pas simples à utiliser) ou d'un niveau de verbosité pour les évènements (ex. Disposer de plus ou moins d'informations sur un parcours client)

+ Niveaux de log

trace
je suis passé par là
trop verbeuses

debug
infos précises jusqu'en intégration
à activer en cas de problème à résoudre (même en prod)

info
trace qui fait partie du contrat de service de l'objet émetteur (ex: pour exploitation normale des traces)

warning
erreur détectée, on continue mais à corriger !
Attention : si c'est une possibilité prévue par le contrat de service, pas warning ni info, mais plutôt debug (car sinon la trace risque de polluer les logs alors que c'est légitime)
exemple à donner (JSF ? / SLF4J)

error
erreur détectée ; service dégradé ou impossible

fatal
erreurs inattendues try/catch(Exception) au plus haut niveau (point d'entrée du service)
    -> mail/alerte à la cellule de gestion des incidents (le service n'a pas pu être rendu)
    -> ajouter dans la trace l'action / la requête / les données à l'origine de l'erreur, car en production, les niveaux inférieurs (debug, ...) qui contiennent ces infos risquent d'être filtrés


    ex: pour les servlet, override http://docs.oracle.com/javaee/6/api/javax/servlet/Servlet.html#service%28javax.servlet.ServletRequest,%20javax.servlet.ServletResponse%29 avec juste un try contenant un appel au parent et un catch(Exception) le lancement de l'alerte
    init et destroy éventuellement
    => mais attention, toutes ces méthodes retournent un statut d'erreur à l'appelant, on est donc capable de détecter les erreurs (sauf s'il s'agit d'un prestataire externe qui ne nous remonte pas ces erreurs)
    L'avantage de #service est qu'il englobe doGet, doPost, ...


+ niveau de confidentialité

un logger par niveau de confidentialité ?
-> peu être suffisant la plupart du temps : confidentiel / pas confidentiel

Cela implique de récupérer le logger sécurisé lorsqu'une donnée l'est.

Ce logger possède lui aussi tous les niveaux de log (trace -> fatal).


+ selon le niveau de confidentialité certains infos peuvent être tracées mais masquées
=> utilitaire pour remplacer les mots de passe par xxxx




+ "Self control"

à l'initialisation : vérifier sa propre configuration et la tracer (+ confidentialité)

à la demande : ex: une servlet/JSP dédiée qui va accéder à tous les composants et vérifier leur état courant

le meilleur endroit pour faire les vérifications est dans l'objet lui-même (ou dans une sous-classe), car c'est lui qui connait son fonctionnement interne et ses parties importantes

pb scope (ex: servlet n'est accessible que depuis le scope request => on doit l'appeler pour l'instancier et qu'elle puisse vérifier son état)

bien faire la différence entre debug et surveillance

attention à la sécurité : effet backdoor / injection de code / ...
=> pas nécessaire de retourner des infos dans le corps de la réponse, on peut juste provoquer des logs dans un fichier particulier (mais attention à l'exploitabilité par des robots de surveillance)

ne pas oublier la méthode HTTP HEAD, qui est déjà pensée pour ce rôle (mais permet seulement de tester qu'une URL répond bien -> ne teste pas de manière aussi complète qu'un "inner test")

ex. d'URL : /maservlet?check=status => vérifie la configuration et affiche/trace un rapport
            /maservlet?check=error => simule une erreur (pour vérifier les mécanismes de surveillance)

=> nécessite un token d'activation pour ne pas spammer, ou plus simple : un filtrage par adresse IP, une vérification de certificat client (mais ça complique le code)
Un simple token partagé et non diffusé peut faire l'affaire !
