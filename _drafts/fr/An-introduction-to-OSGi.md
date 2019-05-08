---
layout: post
title: An introduction to OSGi
date: 2014-05-21 09:55:52 +0100
tags:
  - java
  - OSGi
---

Présentation d'OSGi



Cf http://www.osgi.org/Technology/WhyOSGi



TODO



   OSGi + JNDI
   OSGi filters



Types d'assets



OSGI bundle



   ~ équivalent à des JAR et WAR (-> WAB)
   en plus : des méta-données dans META-INF/MANIFEST.MF
   facultatif : méta-données sur la persistence (bundle JPA)
   définit ses dépendances envers d'autres bundles OSGi
   les JAR peuvent également contenir des EJB, du JPA



Application bundle (.EBA)



   ~ équivalent à un EAR
   regroupement de bundles OSGi et de WAR
   ne peut pas importer / exporter de packages
   contient META-INF/APPLICATION.MF
   chaque application possède son propre service registry
   définit les services exportés et importés (dépendances)



Deployment bundle



   Généré au moment du déploiement d'un EBA : META-INF/DEPLOYMENT.MF
   vision à plat de toutes les dépendances, y compris transitives
   non éditable



Composite bundle (.CBA)



   regroupement de bundles
   importe / exporte des packages
   importe / exporte des services
   contient META-INF/COMPOSITEBUNDLE.MF



Blueprint bundle



   <=> Spring dynamic modules
   contient des fichiers XML blueprint dans OSGI-INF/blueprint/
   blueprint = framework d'injection de dépendance de services / beans en XML (<=> Spring application context)
   blueprint permet de faire le wiring des services, beans







Avantages et inconvénients



Avantages



   Gestion des dépendances à chaud (utile pour la cartographie ?)
   Cycle de vie des bundles indépendant de celui du serveur
   Plusieurs versions du même bundle au même moment : classloader isolés
   Maven-ready (à vérifier) : http://books.sonatype.com/mcookbook/reference/osgi.html
   Dés/installation à chaud
       cf également le concept d'activator
       cf également le concept de fragment
       mode "preview" avant de valider l'update
   un bundle OSGi reste un JAR normal (entrées dans le MANIFEST)
   LogService :
       intégration seamless avec SLF4J ?
   plus portable que les shared libraries Websphere
   EBA (OSGi application) :
       composé d'autres bundles OSGi => mise à jour par module possible
       déclaration des services importés et exportés



Points à vérifier / inconvénients potentiels



   Pas aussi transparent qu'une shared lib (pour le développeur) :
       il y a une interface d'appel (de service) à respecter => refactoring du code nécessaire pour migrer shlib -> OSGi
       cf http://pic.dhe.ibm.com/infocenter/wasinfo/v8r5/topic/com.ibm.websphere.osgi.nd.doc/ae/ra_convert_ear_to_osgi.html
   Maturité dans WAS 8.5.5 (http://pic.dhe.ibm.com/infocenter/wasinfo/v8r5/index.jsp?topic=%2Fcom.ibm.websphere.osgi.doc%2Fae%2Fca_about.html) ?
   Aspects performance / sécurité ?
   LogService :
       permet de récupérer les infos du MDC / les marqueurs ?
       mise en cache des messages confidentiels ?
   Déclaration explicite des packages exportés
   Déploiement à chaud implique une indisponibilité temporaire des services / bundles ?
   Un EBA doit être un composant SCA pour exporter/importer ses services ?
   Restrictions connues : http://pic.dhe.ibm.com/infocenter/wasinfo/v8r5/index.jsp?topic=%2Fcom.ibm.websphere.osgi.nd.doc%2Fae%2Fra_restrict.html
   conversion automatique EAR -> EBA possible seulement s'il ne contient que des WAR (pas de JAR ni d'EJB)
   En mode normal, augmentation des ressources nécessaires (<=> shlib en mode multiple)
   En mode "shared" bundle <=> isolated shared library



Pros / Cons shared libs



Avantages d'OSGi sur les shlib



   portable JEE, pas seulement Websphere
   plug à chaud (pas les shlib ?)
   contrôle à chaud des versions installées et utilisées (pas les shlib ?)
   déclaration de services (shlib = seulement des ressources)



Inconvénients d'OSGi sur les shlib



   migration nécessaire (outillée mais opérations manuelles nécessaires)
   maturité des produits et sensibilisation des utilisateurs ?
