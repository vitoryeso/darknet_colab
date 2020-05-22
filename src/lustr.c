#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lustr.h"

void luCat(char *left, char *right)
{
    printf("len left: %d \n len right: %d \n", strlen(left), strlen(right));
    left = (char *) realloc(left, sizeof(char) * (strlen(left) + strlen(right) + 1) );
    strcat(left, right); 
}
char *luCopy(char *output, char *input, const int n_chars)
{
    //we assume that the output has already been allocated.
    int i=0;
    while( *(input) != '\0' && i != n_chars )
    {
        output[i] = *(input);
        input++;
        i++;
    }
    output[i] = '\0';
    return output;
}


char *luReplaceChar(char *input, char find, char replace) 
{
    char * output = (char*)malloc(strlen(input));

    for (int i = 0; i < strlen(input); i++)
    {
            if (input[i] == find) output[i] = replace;
                else output[i] = input[i];
    }

    output[strlen(input)] = '\0';

    return output;
}

char **luSplit(char *input, char delim)
{
    //first go through the input and count the parts which are splitted
    //after alloc pointers and go through again alloc delimited strings
    char *checkpoint = input;
    int count = 0;
    while( *(checkpoint) != '\0')
    {
        if( *(checkpoint) == delim ) count++;
        checkpoint++;
    }
    checkpoint = input;

    char **prov = (char **) malloc( (count + 1) * sizeof(char *) );
    int n_chars = 0;
    count = 0;
    while( *(checkpoint) != '\0')
    {
        if( *(checkpoint) == delim )
        {
            prov[count] = (char *) malloc( (n_chars + 1) * sizeof(char) );
            //strncpy(prov[count], input, n_chars);
            luCopy(prov[count], input, n_chars);
            input += (n_chars + 1);
            count++;
            n_chars = 0;
            checkpoint++;
            continue;
        }
        n_chars++;
        checkpoint++;
    }
    prov[count] = (char *) malloc( (n_chars + 1) * sizeof(char) );
    luCopy(prov[count], input, n_chars);
    //strncpy(prov[count], input, n_chars);
    return prov;
}


