#include <stdio.h>
#include <stdlib.h>

void printarr(int array[], int arrlen) {
    int i = 0;
    while(i < arrlen) {
        int curr = array[i];
        fprintf(stdout, "%d --> %d\n", i, curr);
        i++;
    }
    return;
}

int main(int argc, char* argv[]) {

    int i = 1;
    int arrlen = argc - 1;
    int nums[arrlen];
    while(i < argc) {
        nums[i-1] = atoi(argv[i]);
        i++;
    }
    
    i = 0;
    int max = 0;
    fprintf(stdout, "Presorted order:\n");
    printarr(nums, arrlen);
    fprintf(stdout, "\nSorted order:\n");
    i = 1;
    while(i < arrlen) {
        int j = i;
        while(j > 0 && nums[j-1] > nums[j]) {
            int temp = nums[j];
            nums[j] = nums[j-1];
            nums[j-1] = temp;
            j--;
        }
        i++;
    }
    printarr(nums, arrlen);
    i = 0;
    return 0;
}
