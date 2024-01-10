#include <stdio.h>
#include <stdlib.h>

int main()
{

    // Create ptr and allocate for int
    int* ptr = (int*)malloc(sizeof(int));

    // Set pointer's pointed to value
    *ptr = 55;

    // Now print pointers value
    printf("%d \n", *ptr);

    // Print pointed to address
    printf("%p \n", ptr);

    // Print pointers address
    printf("%p \n", &ptr);

    return 0;

}