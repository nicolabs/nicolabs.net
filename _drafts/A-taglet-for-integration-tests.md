---
title: A taglet for integration tests
layout: post
date: 2012-08-10 12:21:11 +0100
tags:
  - java
  - javadoc
---

{Standard Doclet = celui de Sun} implements {Doclet}



Doclet = moteur d'analyse des tags. Permet d'ajouter des options et de faire ce qu'on veut des tags. On peut écrire from scratch ou étendre/modifier le standard doclet.

=> à voir comme un **remplacement** du standard doclet





Taglet = utiliser le standard doclet pour ajouter des tags persos ?

=> à voir comme un **plugin** (ajout de tags) à un doclet





Option -tag du standard doclet : crée un taglet générique du même style que @return


References

The Javadoc Tool home page - http://www.oracle.com/technetwork/java/javase/documentation/index-jsp-135444.html

Introduction to the doclet API - http://docs.oracle.com/javase/1.5.0/docs/guide/javadoc/doclet/overview.html

Introduction to the taglet API - http://docs.oracle.com/javase/1.5.0/docs/guide/javadoc/taglet/overview.html

Some open source taglets - http://taglets.sourceforge.net/

The standard doclet (1.4.2) - http://docs.oracle.com/javase/1.4.2/docs/tooldocs/javadoc/standard-doclet.html

The standard doclet (7) - http://docs.oracle.com/javase/7/docs/technotes/guides/javadoc/standard-doclet.html

Source for the JDK - http://jdk7.java.net/source.html
