#include <stdio.h>
#include <stdlib.h>

// Create node struct for linked list
struct Node
{

    int val;
    struct Node *next;

};

int main()
{
    // Create head
    struct Node* head = (struct Node*)malloc(sizeof(struct Node));

    // Create tmp which will create other links
    struct Node* tmp = head;

    // Create links and their vals
    for(int i = 0; i < 4; i++){
    
        tmp->next = (struct Node*)malloc(sizeof(struct Node));
        tmp->val = i;
        tmp = tmp->next;

    }

    // Reset to start
    tmp = head;

    // Now print links vals
    for(int i = 0; i < 4; i++){
    
        printf("%d \n", tmp->val);
        tmp = tmp->next;

    }

    return 0;

}