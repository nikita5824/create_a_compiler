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


%%
{DIGIT}+|int\({DIGIT}\)|int\({BIN}\)|int\({OCT}\)|int\({HEX}\)|int\({FLOAT}\) {TLex* lex = new TLex; lex->_name = "int decimal"; return lex;}

{BIN}|bin\({DIGIT}\)|bin\({BIN}\)|bin\({OCT}\)|bin\({HEX}\) {TLex* lex = new TLex; lex->_name = "int binary"; return lex;}

0o[0-7]|oct\({DIGIT}\)|oct\({BIN}\)|oct\({OCT}\)|oct\({HEX}\) {TLex* lex = new TLex; lex->_name = "int octal"; return lex;}

0x[0-9A-F]+|hex\({DIGIT}\)|hex\({BIN}\)|hex\({OCT}\)|hex\({HEX}\) {TLex* lex = new TLex; lex->_name = "int hexadecimal"; return lex;}

{FLOAT}|float\({DIGIT}\)|float\({BIN}\)|float\({OCT}\)|float\({HEX}\)|float\({FLOAT}\) {TLex* lex = new TLex; lex->_name = "float"; return lex;}

True|False|class|finally|is|return|None|continue|for|lambda|try|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise {TLex* lex = new TLex; lex->_name = "key_word"; return lex;}

\+|\-|\*|\/|\/\/|\%|\*\* {TLex* lex = new TLex; lex->_name = "arithmetic operation"; return lex;}

%%
int main() {
    TLex* yyin = 0;
    do {
        yyin = nextLex();
        std::cout << yyin->_name << std::endl;
    } while(yyin!=0);

    return 0;
}