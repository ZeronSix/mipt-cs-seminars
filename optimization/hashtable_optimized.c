#include "hashtable.h"
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define INLINE_HASH(label) \
        "mov eax, 0\n\t" \
        "xor r8, r8\n\t" \
        "loop" label "_cond:\n\t" \
        "xor r8, r8\n\t" \
        "movzx r8, byte ptr [rdi]\n\t"   \
        "test r8b, r8b\n\t" \
        "je loop" label "_end\n\t" \
        "add eax, r8d\n\t" \
        "mov r8d, eax\n\t" \
        "sal r8d, 10\n\t" \
        "add eax, r8d\n\t" \
        "mov r8d, eax\n\t" \
        "shr r8d, 6\n\t" \
        "xor eax, r8d\n\t" \
        "inc rdi\n\t" \
        "jmp loop" label "_cond\n\t" \
        "loop" label "_end:\n\t" \
        "mov r8d, eax\n\t" \
        "sal r8d, 3\n\t" \
        "add eax, r8d\n\t" \
        "mov r8d, eax\n\t" \
        "shr r8d, 11\n\t" \
        "xor eax, r8d\n\t" \
        "mov r8d, eax\n\t" \
        "sal r8d, 15\n\t" \
        "add eax, r8d\n\t" \
        "mov ebx, 3007\n\t" \
        "xor edx, edx\n\t" \
        "div ebx\n\t" \
        "mov eax, edx\n\t" 

static unsigned hash(const char* str) {
    asm(".intel_syntax noprefix\n\t"
        INLINE_HASH("1")
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

        INLINE_HASH("2")
        
        "mov rax, [r9 + 8 * rax]\n\t"
        "searchloop_cond:\n\t"
        "test rax, rax\n\t"
        "je searchloop_end\n\t"
        "mov rdi, r10\n\t"
        "mov rsi, [rax+8]\n\t"
        "mov r11, rax\n\t"
        // strcmp
        "xor r12, r12\n\t"
        "strcmp_cond:\n\t"
        "mov rax, 1\n\t"
        "mov r13, [rdi + r12]\n\t"
        "mov r14, [rsi + r12]\n\t"
        "cmp r13, r14\n\t"
        "jne strcmp_end\n\t"
        "inc r12\n\t"
        "cmp r13, 0\n\t"
        "jne  strcmp_cond\n\t"
        "mov rax, 0\n\t"
        "strcmp_end:\n\t"
        "mov esi, eax\n\t"
        "mov rax, r11\n\t"
        "test esi, esi\n\t"
        "je searchloop_end\n\t"
        "mov rax, [rax]\n\t"
        "jmp searchloop_cond\n\t"
        "searchloop_end:\n\t"
        :
        :
        : "%rax", "%r9", "%r10", "%rdi", "%rsi", "%r11", "%r12", "%r13", "%r14", "%rcx", "%rdx"
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

