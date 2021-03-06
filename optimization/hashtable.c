#include "hashtable.h"
#include <stddef.h>
#include <string.h>
#include <stdlib.h>

static unsigned hash(const char* str) {
    unsigned hashval = 0;

    for (; *str; str++) {
        hashval  += (unsigned char)(*str);
        hashval  += (hashval  << 10);
        hashval  ^= (hashval  >> 6);
    }

    hashval  += (hashval  << 3);
    hashval  ^= (hashval  >> 11);
    hashval  += (hashval  << 15);

    return hashval % BUCKET_COUNT;
}

HtItem* ht_search(HashTable* ht, const char* s) {
    HtItem*  ptr  = NULL;
    unsigned h    = hash(s);

    for (ptr = ht->buckets[h]; ptr != NULL; ptr = ptr->next)
        if (strcmp(s, ptr->str) == 0) {
            //printf("%s found!\n", s);
            return ptr;
        }
    return NULL;
}

int ht_insert(HashTable* ht, const char* s) {
    if (ht_search(ht, s) == NULL) {
        HtItem* item = (HtItem*)calloc(1, sizeof(*item));
        unsigned h = hash(s);
        item->next = ht->buckets[h];
        item->str  = s;
        ht->buckets[h] = item;
    }
    return 0;
}

