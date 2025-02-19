# DM-THL
# **Projet : Interpréteur d'Expressions Ensemblistes avec Flex et Bison**

## **1. Concept du Projet**
L'objectif de ce projet est de concevoir et d'implémenter un interpréteur d'expressions ensemblistes en utilisant **Flex et Bison**. Cet interpréteur devra :
- Analyser et exécuter des expressions ensemblistes.
- Gérer les opérations d'union, d'intersection, de complémentaire, de cardinalité et d'affectation d'ensembles.
- Supprimer automatiquement les doublons dans les ensembles.
- Gérer les erreurs lexicales et syntaxiques avec des messages explicites.
- Afficher les résultats des expressions soumises par l'utilisateur.

Le projet devra être développé sur **GitHub**, avec des commits réguliers documentant l'évolution du travail.

---

## **2. Objectifs du Projet**
- Implémenter un **analyseur lexical** et un **analyseur syntaxique** robustes avec **Flex et Bison**.
- Créer une **représentation efficace des ensembles** utilisant des opérations bit à bit.
- Assurer une **gestion rigoureuse des erreurs** et des priorités entre opérateurs.
- Rendre le projet extensible avec des **fonctionnalités avancées** (tests d'égalité, inclusion, gestion des grands ensembles, etc.).

---

## **3. Mécanismes du Projet**

### 🗂️ **Analyseur Lexical**
- Utilisation de **Flex** pour la détection des tokens.
- Identificateurs d'ensembles nommés par une seule lettre (majuscule ou minuscule, insensible à la casse).
- Ensembles délimités par `{}` et contenant des entiers entre **1 et 63**.
- Opérateurs supportés : `union`, `inter`, `comp`, `-`, `card`.
- Opérateur d'affectation : `:=`.
- Une expression se termine par un saut de ligne (`\n`).

### 📌 **Analyseur Syntaxique**
- Implémentation de la grammaire avec **Bison**.
- Reconnaissance des expressions ensemblistes valides.
- Gestion des erreurs syntaxiques avec `printError()`.
- Exemples d'analyse syntaxique :
  - `A := {1,2} union {3,4}` → `Expression syntaxiquement correcte.`
  - `D := card {1,1,2,2,3}` → `D = 3` (suppression des doublons).

### ⚡ **Analyse Sémantique et Exécution**
- Chaque ensemble est représenté par un **`unsigned long long` (64 bits)**.
- Opérations ensemblistes implémentées avec des **opérations bit à bit**.
- Exemples :
  - `B := A inter {2,3}` (avec `A = {1,2,3,4}`) → `B = {2,3}`
  - `D := {1,2,3} comp {2,3}` → `D = {1}`

### ❌ **Gestion des Erreurs et Priorités**
- Détection des erreurs d'affectation :
  - `A := card(A)` → `Erreur : Impossible d'affecter une valeur numérique à un ensemble.`
- Système de priorités entre `union`, `inter` et `comp`.
- Prise en compte des parenthèses dans les expressions.

### 🔧 **Extensions du Langage**
- **Identificateurs d'ensemble de plus d'une lettre**.
- **Gestion d'ensembles de plus de 64 éléments**.
- **Tests d'égalité (`=`) et d'inclusion (`in`)**.
- **Union multiple** : `union({1,2}, {3,4}, {5,6})`.
- Exemples :
  - `D := union({1,2}, {3,4}, {5,6})` → `D = {1,2,3,4,5,6}`
  - `E := {1,2,3} = {1,2,3}` → `E = true`
  - `F := {1,2} in {1,2,3,4}` → `F = true`

---

## **4. Technologies et Architecture**

### 💻 **Technologies Utilisées**
- **Flex** pour l'analyse lexicale.
- **Bison** pour l'analyse syntaxique.
- **C (gcc)** pour l'implémentation du programme.
- **GitHub** pour le suivi et le versionnement du projet.

### 🏗️ **Architecture du Code**
- `lexer.flex` : Définition des tokens et analyse lexicale.
- `parser.y` : Implémentation de la grammaire et analyse syntaxique.
- `main.c` : Gestion de l'entrée utilisateur et exécution des expressions.
- `set_operations.c/h` : Fonctions pour manipuler les ensembles avec des opérations bit à bit.
- `error_handling.c/h` : Fonctions de gestion des erreurs.

---

## **5. Livrables**
- **Dépôt GitHub** avec commits réguliers.
- **Dossier zippé contenant** :
  - Fichiers sources du projet.
  - **Makefile** permettant de compiler et exécuter l'interpréteur :
    ```bash
    $ make set_interpreter
    $ ./set_interpreter < fichier_test.txt
    ```
  - **Rapport (5 pages max)** expliquant les choix techniques et les difficultés rencontrées.

