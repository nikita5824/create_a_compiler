%option noyywrap
%{
#include <string.h>
#include <iostream>
#include "unistd.h"

class TLex
{
public:
    std::string _name;
    int _num;
};
#define YY_DECL TLex* nextLex()
%}

DIGIT [0-9]+
BIN 0b[01]+
OCT 0o[0-7]+
HEX 0x[0-9A-F]+
FLOAT {DIGIT}*\.{DIGIT}+|{DIGIT}+\.|{DIGIT}+e-?{DIGIT}+
LOG_OP and|or|not|<|>|==|<=|>=|!=

SEPARATOR (|)|[|]|,|:|{|}
ASSIGNMENT =|+=|-=|*=|/=|%=
ONELINECOMMENTS #
MULTILINECOMMENTS \'{3}|\"{3}

%%
{DIGIT}+|int\({DIGIT}\)|int\({BIN}\)|int\({OCT}\)|int\({HEX}\)|int\({FLOAT}\) {
    TLex* lex = new TLex; 
    lex->_name = "int decimal"; 
    return lex;
}

{BIN}|bin\({DIGIT}\)|bin\({BIN}\)|bin\({OCT}\)|bin\({HEX}\) {
    TLex* lex = new TLex; 
    lex->_name = "int binary"; 
    return lex;
}

0o[0-7]|oct\({DIGIT}\)|oct\({BIN}\)|oct\({OCT}\)|oct\({HEX}\) {
    TLex* lex = new TLex; 
    lex->_name = "int octal"; 
    return lex;
}

0x[0-9A-F]+|hex\({DIGIT}\)|hex\({BIN}\)|hex\({OCT}\)|hex\({HEX}\) {
    TLex* lex = new TLex; 
    lex->_name = "int hexadecimal"; 
    return lex;
}

{FLOAT}|float\({DIGIT}\)|float\({BIN}\)|float\({OCT}\)|float\({HEX}\)|float\({FLOAT}\) {
    TLex* lex = new TLex; 
    lex->_name = "float"; 
    return lex;
}

\+|\-|\*|\/|\/\/|\%|\*\* {
    TLex* lex = new TLex; 
    lex->_name = "arithmetic operation"; 
    return lex;
}

{LOG_OP} {
    TLex* lex = new TLex; 
    lex->_name = "logical operation"; 
    return lex;
}

{ONELINECOMMENTS}+[a-zA-Z0-9_\- ]+[^{ONELINECOMMENTS}]\n {
    TLex* lex = new TLex; 
    lex->_name = "oneline comment"; 
    return lex;
}

{MULTILINECOMMENTS}+[a-zA-Z0-9_\- \'\"]+{MULTILINECOMMENTS}?\n {
    TLex* lex = new TLex; 
    lex->_name = "multiline comment"; 
    return lex;
}


%%
int main() {
    TLex* yyin = 0;
    do {
        yyin = nextLex();
        std::cout << yyin->_name << std::endl;
    } while(yyin!=0);

    return 0;
}