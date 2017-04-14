#include <stddef.h>

void test()
{

}

int main()
{
    int* x = 0;
    test();
    x = (int*)&x;
    x = NULL;
    test();
    return 0;
}
