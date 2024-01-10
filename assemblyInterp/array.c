#include <stdio.h>

int main()
{
    // Set new array of size 100
    int arr[100];

    // Set values in increasing order
    for(int i = 0; i < 100; i++){
        arr[i] = i;
    }

    // Print in order
    for(int i = 0; i < 100; i++){
        printf("%d \n", arr[i]);
    }

    return 0;

}