#include <stdio.h>

extern void printfex();

int main()
{
    printfex("I love %x %d%c %s\n", 3802, 100, '%', "!TEST!");
    printfex("%x %d%c %s\n", 3802, 100, '%', "!TEST!");
    return 0;
}
