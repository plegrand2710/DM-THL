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

## 📌 Version 2.1 - [11/03/2025] Pauline

### 🔹 **Finalisation de l'analyseur sémantique et ajustements**
Cette version marque la **finalisation complète de l'analyseur sémantique**, assurant une gestion correcte des ensembles et des opérations ensemblistes.  
Le fichier a été **renommé `set_interpreter`** pour coller aux exigences du projet et aux consignes.  

L’implémentation repose **principalement sur le fichier `lexer.bison` développé dans la version précédente**, avec des corrections et des améliorations visant à stabiliser et optimiser l’exécution.  

---

### **🛠 Problèmes rencontrés et solutions apportées**
#### **1️⃣ Correction de la gestion des erreurs et récupération après une erreur**
🔴 **Problème** :  
- Certaines erreurs interrompaient totalement l’analyse au lieu de simplement ignorer l'expression incorrecte.  
- Un `TOKEN_NEWLINE` inattendu empêchait l’analyse des expressions suivantes.  

🟢 **Solutions apportées** :  
- **Ajout d'une gestion robuste des erreurs** avec `yyerrok; yyclearin;` pour éviter le blocage de l’analyse après une erreur.  
- **Ajout d’une règle `error TOKEN_NEWLINE`** pour garantir que le parseur continue après une erreur de syntaxe.  

---

#### **2️⃣ Correction du calcul de `card`**
🔴 **Problème** :  
- `card {10,20,30,40,50,60}` retournait systématiquement une cardinalité de 3, peu importe l’ensemble.  
- `card B` ne fonctionnait pas si `B` n'était pas encore défini.  

🟢 **Solutions apportées** :  
- **Correction de l’algorithme de calcul de cardinalité** pour compter correctement les éléments d’un ensemble en utilisant les opérations bit à bit.  
- **Ajout d’une vérification de l'existence d'une variable avant d'évaluer `card IDENT`**.  

---

#### **3️⃣ Suppression du conflit `shift/reduce` sur `TOKEN_NEWLINE`**
🔴 **Problème** :  
- `TOKEN_NEWLINE` entraînait un conflit de type **réduction/réduction**, causé par l’ambiguïté entre `card {}` et `card IDENT`.  

🟢 **Solution** :  
- **Réorganisation de la grammaire et clarification de la règle `expression`** pour résoudre le conflit.  

---

#### **4️⃣ Vérification des priorités et des opérateurs**
🔴 **Problème** :  
- Les opérations `union`, `inter`, `comp`, `diff` ne respectaient pas toujours les priorités définies (`%left`, `%right`).  

🟢 **Solution** :  
- **Révision et consolidation des règles de priorité (`%left` pour `union`, `inter`, etc.)** pour garantir une bonne évaluation des expressions.  

---

### **📌 Fonctionnalités finales après correction**
✅ **Correction de la gestion des erreurs et récupération après une erreur**.  
✅ **Calcul correct de `card {}` et `card IDENT`**.  
✅ **Suppression du conflit `shift/reduce`**.  
✅ **Gestion propre des opérations ensemblistes avec respect des priorités**.  
✅ **Renommage du fichier en `set_interpreter` pour respecter la consigne**.  

---

### **📌 Fonctionnalités non encore implémentées**
❌ **Gestion des ensembles de plus de 64 éléments** (limité à 64 bits).  
❌ **Opérations avancées (`A in B`, `A = B`)**.  
❌ **Prise en charge des identificateurs complexes (`Var1`, `abcXYZ` fonctionnent, mais `123Var` pose problème).**  

---

## **📌 Prochaines étapes**
✔ **Optimiser le calcul des ensembles pour améliorer les performances**.  
✔ **Tester un plus grand nombre de cas limites pour valider la robustesse**.  
✔ **Améliorer la gestion des erreurs pour les cas encore non couverts**.  

