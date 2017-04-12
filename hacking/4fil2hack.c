/*!
 * \file
 * Contains the stages with password check to be hacked.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

enum 
{
    ERR_ACCESS_DENIED = 1
};

void grant_root_access(void)
{
    puts("Congratulations!!! Root access granted!");
}

void access_denied(void)
{
    puts("Access denied, dumbass. BOOOOOOM!");
    exit(ERR_ACCESS_DENIED);
}

void phase1(void)
{
    static const char* passwd = "obshefiz gоvno\n";
    
    char buffer[50] = {};
    if (strcmp(fgets(buffer, 50, stdin), passwd) == 0)
        grant_root_access();
    else
        access_denied();
}

unsigned int hash(const char* str)
{
    unsigned int hash = 0;
    while (*str)
    {
        hash += (*str) >> 1;
        str++;
    }

    return hash;
}

void phase2(void)
{
    // password is "kek\n"
    static const unsigned int PHASE2_HASH = 161;
    
    char buffer[50] = {};
    if (hash(fgets(buffer, 50, stdin)) == PHASE2_HASH)
        grant_root_access();
    else
        access_denied();
}

unsigned int faq6(const char* str)
{
    unsigned int hash = 0;

    for (; *str; str++)
    {
        hash += (unsigned char)(*str);
        hash += (hash << 10);
        hash ^= (hash >> 6);
    }
    hash += (hash << 3);
    hash ^= (hash >> 11);
    hash += (hash << 15);

    return hash;
}

int check_password_phase3(const char* str)
{
    // password is "640 kB ought to be enough for anybody\n"
    static const unsigned int PHASE3_HASH = 1280045920;

    return faq6(str) == PHASE3_HASH;
}

void phase3(void)
{
    char buffer[30] = {};
    gets(buffer);

    // use function call to allow for stack smashing
    if (check_password_phase3(buffer))
        grant_root_access();
    else
        access_denied();
}

int main()
{
    puts("Here's a little warmup.");
    puts("Starting phase 1...");
    phase1();
    puts("Good job! Starting phase 2..."); 
    phase2();
    puts("Good! Now it's time for some old-school hacking. Starting phase 3...");
    phase3();
    puts("Nice! All phases have been passed.");
    
    return 0;
}
