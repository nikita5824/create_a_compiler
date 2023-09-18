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
LOG_OP <|>|==|<=|>=|!=
KEY_WORD True|False|class|finally|is|return|None|continue|for|lambda|try|def|from|nonlocal|while|and|del|global|not|with|as|elif|if|or|yield|assert|else|import|pass|break|except|in|raise
SEPARATOR (|)|[|]|,|:|{|}
ASSIGNMENT =|+=|-=|*=|/=|%=
ONELINECOMMENTS #
MULTILINECOMMENTS \'{3}|\"{3}

%%
\s*(-?({DIGIT}+|int\({DIGIT}\)|int\({BIN}\)|int\({OCT}\)|int\({HEX}\)|int\({FLOAT}\)))\s* {
    TLex* lex = new TLex; 
    lex->_name = "int"; 
    return lex;
}

\s*(-?({BIN}|bin\({DIGIT}\)|bin\({BIN}\)|bin\({OCT}\)|bin\({HEX}\)))\s* {
    TLex* lex = new TLex; 
    lex->_name = "int binary"; 
    return lex;
}

\s*(-?(0o[0-7]+|oct\({DIGIT}\)|oct\({BIN}\)|oct\({OCT}\)|oct\({HEX}\)))\s* {
    TLex* lex = new TLex; 
    lex->_name = "int octal"; 
    return lex;
}

\s*(-?(0x[0-9A-F]+|hex\({DIGIT}\)|hex\({BIN}\)|hex\({OCT}\)|hex\({HEX}\)))\s* {
    TLex* lex = new TLex; 
    lex->_name = "int hexadecimal"; 
    return lex;
}

\s*(-?({FLOAT}|float\({DIGIT}\)|float\({BIN}\)|float\({OCT}\)|float\({HEX}\)|float\({FLOAT}\)))\s* {
    TLex* lex = new TLex; 
    lex->_name = "float"; 
    return lex;
}

\+|\-|\*|\/|\/\/|\%|\*\* {
    TLex* lex = new TLex; 
    lex->_name = "arithmetic operation"; 
    return lex;
}

(\'|\")[a-zA-Z0-9\s]*(\'|\") {
    TLex* lex = new TLex; 
    lex->_name = "string"; 
    return lex;
}

\s*{LOG_OP}\s* {
    TLex* lex = new TLex; 
    lex->_name = "logical operation"; 
    return lex;
}

\s*(if|else|elif)\s* {
    TLex* lex = new TLex; 
    lex->_name = "control structure"; 
    return lex;
}

\s*(\+=|\-=|\*=|\/=|%=|=)\s* {
    TLex* lex = new TLex; 
    lex->_name = "assignment"; 
    return lex;
}

\s*(\(|\)|\[|\]|\:|\{|\})\s* {
    TLex* lex = new TLex; 
    lex->_name = "separator"; 
    return lex;
}

(for|while|do) {
    TLex* lex = new TLex; 
    lex->_name = "cycle"; 
    return lex;
}

{KEY_WORD} {
    TLex* lex = new TLex; 
    lex->_name = "key word"; 
    return lex;
}

[a-zA-Z_][a-zA-Z0-9_]*\s* {
    TLex* lex = new TLex; 
    lex->_name = "identifier"; 
    return lex;
}

{ONELINECOMMENTS}+[a-zA-Z0-9_\- ]+[^{ONELINECOMMENTS}] {
    TLex* lex = new TLex; 
    lex->_name = "oneline comment"; 
    return lex;
}

{MULTILINECOMMENTS}+[a-zA-Z0-9_\- \'\"]+{MULTILINECOMMENTS}? {
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