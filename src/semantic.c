#include <stdio.h>
#include <stdlib.h>

// Vérifie si une valeur est bien un ensemble (bitmask <= 63 bits)
int is_set(unsigned long long value) {
    return (value & ~0xFFFFFFFFFFFFFFFFULL) == 0; // Vérifie que seuls les 63 premiers bits sont utilisés
}

// Vérification des types avant l'exécution des opérations
void check_types(char op, unsigned long long a, unsigned long long b) {
    switch (op) {
        case 'U': // Union
        case 'I': // Intersection
        case 'C': // Complémentaire
        case 'D': // Différence
            if (!is_set(a) || !is_set(b)) {
                fprintf(stderr, "Erreur sémantique : Opération ensembliste appliquée à un non-ensemble.\n");
                exit(EXIT_FAILURE);
            }
            break;
        case 'R': // Cardinalité
            if (!is_set(a)) {
                fprintf(stderr, "Erreur sémantique : 'card' doit être appliqué à un ensemble.\n");
                exit(EXIT_FAILURE);
            }
            break;
        default:
            fprintf(stderr, "Erreur sémantique inconnue.\n");
            exit(EXIT_FAILURE);
    }
}

