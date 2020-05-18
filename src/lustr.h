#ifndef LUSTR_H
#define LUSTR_H

char *replace_char(char *input, char find, char replace);
char **luSplit(char *input, char delim);
char *luCopy(char *output, char *input, const int n_chars);


#endif
