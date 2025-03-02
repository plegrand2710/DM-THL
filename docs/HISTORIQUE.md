# Historique des modifications

Ce fichier suit les changements majeurs apportés au projet. Chaque version est documentée avec une description des nouvelles fonctionnalités, corrections de bugs, améliorations et modifications importantes.

---

## 📌 Version 1.0 - [22/02/2025] Lennon
### 🔹 Ajout de l'analyseur lexical (lexer.flex)
- Implémentation de l'analyseur lexical avec **Flex**.
- Gestion des **opérateurs ensemblistes** : `union`, `inter`, `comp`, `-`, `card`.
- Prise en charge de **l'affectation** avec `:=`.
- Reconnaissance des **délimiteurs et séparateurs** : `{}`, `,`, `\n`.
- Ajout de la gestion des **identificateurs d'ensembles** (`A-Z` ou `a-z`).
- Ajout de la gestion des **nombres** compris entre **1 et 63**.
- Détection et affichage des **erreurs lexicales** (`TOKEN_UNKNOWN`).

### ✅ Test et validation
- **Fichier de test** : `tests/test_lexer.txt` mis à jour avec des cas de test variés.
- **Tests effectués** :
  - Commande : `./lexer < tests/test_lexer.txt`
  - Vérification des **tokens générés** et de la **détection des erreurs**.
  
  ---

## 📌 Version 1.1 - [23/02/2025] Pauline  
### 🔹 Création de l'analyseur syntaxique (`lexer.bison`)  
- **Élaboration et implémentation de la grammaire** pour reconnaître et valider les **expressions ensemblistes**.  
- **Ajout des règles syntaxiques** pour :  
  - L’**affectation d’ensembles** (`A := {1,2,3} union {4,5,6}`), avec gestion des variables.  
  - Les **opérations ensemblistes** (`union`, `inter`, `diff`, `comp`, `card`).  
  - La **définition et l’utilisation des ensembles** (`{1,2,3,4}`), avec une **suppression automatique des doublons**.  
- **Mise en place des priorités (`%left`, `%right`)** pour réduire les conflits `shift/reduce` liés aux opérations `union`, `inter`, `diff`.  
- **Ajout de la gestion des erreurs syntaxiques** :  
  - Détection et affichage des erreurs de syntaxe avec `yyerror()`.  
  - Correction automatique de certaines erreurs mineures avec `yyerrok`.  
- **Prise en charge des expressions imbriquées** :  
  - Support des **parenthèses** pour modifier la priorité (`(A union B) inter C`).  
  - Possibilité d’utiliser des ensembles et des variables dans la même expression.  

### 🔹 Modifications apportées à **lexer.flex**  
- **Amélioration de la gestion des erreurs lexicales** (`TOKEN_UNKNOWN` affiché avec `printError()`).  
- **Activation du mode debug** (`yydebug`) pour voir les étapes de l’analyse lexicale.  

### 🔹 Problèmes rencontrés  
- **Les modifications effectuées ne permettent pas encore une exécution correcte.**  
- **Des erreurs `shift/reduce` persistent**, malgré l’ajout des règles de priorité et des corrections syntaxiques.  
- **Le parsing des expressions (`A := B union {1,2,3}`) ne fonctionne pas toujours correctement.**  
- **Les erreurs de syntaxe ne sont pas toutes détectées correctement**, ce qui entraîne des comportements inattendus lors de l’exécution.  

### 🔹 Prochaines étapes  
- **Corriger les erreurs `shift/reduce`** restantes en affinant la gestion des expressions (`set_expr`).  
- **Vérifier la cohérence entre `lexer.flex` et `lexer.bison`** pour s’assurer que tous les tokens sont bien reconnus et utilisés correctement.  
- **Mettre en place une gestion des erreurs plus robuste** pour détecter plus précisément les fautes de syntaxe.  
- **Tester davantage avec des fichiers de test variés** pour identifier et corriger les cas problématiques.  

---

## 📌 Version 1.2 - [27/02/2025 - 02/03/2025] Pauline
### 🔹 Corrections et améliorations de l’analyseur syntaxique (`lexer.bison`)

Après avoir détecté plusieurs **problèmes bloquants**, une **refonte de l’analyseur syntaxique** a été effectuée.

### 🛠 Problèmes rencontrés et solutions apportées
#### **1️⃣ L’analyseur ne reconnaissait pas certaines expressions correctement**
🔴 **Problème** : Les expressions comme `A := {1,2,3} union {4,5,6}` ne passaient pas toujours.  
🟢 **Solution** : **Réécriture des règles syntaxiques** pour assurer une **bonne reconnaissance des opérations ensemblistes**.  

---

#### **2️⃣ Inclusion problématique de `lexer.h` dans `lexer.flex`**
🔴 **Problème** : L’analyseur **ne reconnaissait pas correctement les tokens générés par Flex**.  
🟢 **Solution** : **Retrait de l’inclusion directe du fichier `lexer.h` dans `.flex`**.  

---

#### **3️⃣ Détection des parenthèses dans les expressions**
🔴 **Problème** : `A := ({1,2,3} union {4,5,6}) inter {7,8,9}` n’était pas bien interprété.  
🟢 **Solution** : **Ajout d’une règle pour détecter les parenthèses et imposer la priorité**.  

---

#### **4️⃣ Refonte complète de la gestion des erreurs**
🔴 **Problème** :  
- **Les erreurs étaient affichées plusieurs fois.**
- **Les expressions suivantes étaient faussement détectées comme erronées.**  
🟢 **Solution** : **Refonte complète de la gestion des erreurs**, inspirée du TD.  
- **Les erreurs sont maintenant détectées une seule fois**.
- **Utilisation de `yyerrok; yyclearin;`** pour éviter que **les erreurs affectent les expressions suivantes**.
- **Affichage des erreurs en rouge avec `proto-color.h`**.

---

#### **5️⃣ Amélioration de l’affichage des erreurs**
🔴 **Problème** : Avant, les erreurs **n’étaient pas claires et difficiles à repérer**.  
🟢 **Solution** : **Ajout de `proto-color.h`** pour afficher les erreurs en **rouge**.  

---

### 📌 Fonctionnalités finales après correction
✅ **Correction des erreurs `shift/reduce`**.  
✅ **Gestion correcte des parenthèses et des priorités (`union`, `inter`, `diff`)**.  
✅ **Détection des erreurs améliorée** (une seule erreur affichée au lieu de plusieurs).  
✅ **Affichage des erreurs en couleur avec `proto-color.h`**.  
✅ **Séparation propre entre `lexer.flex` et `lexer.bison`**.  

---

### 📌 Fonctionnalités non implémentées
❌ **Ensembles de plus de 64 éléments**  
❌ **Tests d’égalité (`A = B`) et inclusion (`A in B`)**  
❌ **Union multiple (`union({1,2}, {3,4}, {5,6})`)**  
✅ **Seules les parenthèses et les identificateurs plus longs ont été implémentés.**  

---

## 📌 Prochaines étapes
✔ **Implémenter l'analyseur sémantique**.  
✔ **Implémenter les opérations bit à bit**.  
✔ **Ajouter les extensions du langage demandées**.  

---


