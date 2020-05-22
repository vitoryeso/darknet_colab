#ifndef LUSTR_H
#define LUSTR_H

void luCat(char *left, char *right);
char *luReplaceChar(char *input, char find, char replace);
char **luSplit(char *input, char delim);
char *luCopy(char *output, char *input, const int n_chars);


#endif
