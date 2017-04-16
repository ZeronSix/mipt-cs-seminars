#include "hashtable.h"
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

static unsigned hash(const char* str) {
    asm(".intel_syntax noprefix\n\t"
        "mov eax, 0\n\t"
        "mov r8, 0\n\t"
        "loop_cond:\n\t"
        "mov r8, 0\n\t"
        "movzx r8, byte ptr [rdi]\n\t"  
        "test r8b, r8b\n\t"
        "je loop_end\n\t"
        "add eax, r8d\n\t"
        "mov r8d, eax\n\t"
        "sal r8d, 10\n\t"
        "add eax, r8d\n\t"
        "mov r8d, eax\n\t"
        "shr r8d, 6\n\t"
        "xor eax, r8d\n\t"
        "inc rdi\n\t"
        "jmp loop_cond\n\t"
        "loop_end:\n\t"
        "mov r8d, eax\n\t"
        "sal r8d, 3\n\t"
        "add eax, r8d\n\t"
        "mov r8d, eax\n\t"
        "shr r8d, 11\n\t"
        "xor eax, r8d\n\t"
        "mov r8d, eax\n\t"
        "sal r8d, 15\n\t"
        "add eax, r8d\n\t"
        "mov ebx, 3007\n\t"
        "mov edx, 0\n\t"
        "div ebx\n\t"
        "mov eax, edx\n\t"
        :
        :
        : "%eax", "%ecx", "%r8", "%rdi", "%edx", "%ebx"
    );
}

HtItem* ht_search(HashTable* ht, const char* s) {
    asm(".intel_syntax noprefix\n\t"
        "mov r9, rdi\n\t" // move ht to r9
        "mov r10, rsi\n\t" // move s to r10
        "mov rdi, r10\n\t"
        "call hash\n\t"
        "mov rax, [r9 + 8 * rax]\n\t"
        "searchloop_cond:\n\t"
        "test rax, rax\n\t"
        "je searchloop_end\n\t"
        "mov rdi, r10\n\t"
        "mov rsi, [rax+8]\n\t"
        "mov r11, rax\n\t"
        "call strcmp@PLT\n\t"
        "mov esi, eax\n\t"
        "mov rax, r11\n\t"
        "test esi, esi\n\t"
        "je searchloop_end\n\t"
        "mov rax, [rax]\n\t"
        "jmp searchloop_cond\n\t"
        "searchloop_end:\n\t"
        :
        :
        : "%rax", "%r9", "%r10", "%rdi", "%rsi", "%r11"
    );
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

