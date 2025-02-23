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
