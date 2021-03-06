%{

#define YY_NO_INPUT 1
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#include "y.tab.h"
#include "ParseTree.h"

void yyerror(char *s);
%}

%option nounput
%x INCLUDEFILE

%%
(([0-9]+|([0-9]+)?\.[0-9]+|[0-9]+\.)[eE][+-]?[0-9]+)|(([0-9]+)?\.[0-9]+|[0-9]+\.) {
    double f = atof(yytext);
    yylval.fvalue = f;
    return REAL;
}

[1-9]+[0-9]*|0 {
    int i = atoi(yytext);
    yylval.ivalue = i;
    return NNINTEGER;
}

pi {
    yylval.svalue = AddString(yytext);
    return PI;
}

sin {
    yylval.svalue = AddString(yytext);
    return SIN;
}

cos {
    yylval.svalue = AddString(yytext);
    return COS;
}

tan {
    yylval.svalue = AddString(yytext);
    return TAN;
}

exp {
    yylval.svalue = AddString(yytext);
    return EXP;
}

ln {
    yylval.svalue = AddString(yytext);
    return LN;
}

sqrt {
    yylval.svalue = AddString(yytext);
    return SQRT;
}

qreg {
    yylval.svalue = AddString(yytext);
    return QREG;
}

creg {
    yylval.svalue = AddString(yytext);
    return CREG;
}

gate {
    yylval.svalue = AddString(yytext);
    return GATE;
}

measure {
    yylval.svalue = AddString(yytext);
    return MEASURE;
}

if {
    yylval.svalue = AddString(yytext);
    return IF;
}

reset {
    yylval.svalue = AddString(yytext);
    return RESET;
}

barrier {
    yylval.svalue = AddString(yytext);
    return BARRIER;
}

opaque {
    yylval.svalue = AddString(yytext);
    return OPAQUE;
}

\"([^\\\"]|\\.)*\" { 
    yylval.svalue = AddString(yytext);
    return STRING;
}

include {
    BEGIN INCLUDEFILE;
}

<INCLUDEFILE>[ \t]*      /* eat the whitespace */
<INCLUDEFILE>[^ \t]+; {
    long size = 0;
    long sizeNeeded = 2200;
    char* contents = NULL;
    while (sizeNeeded > size) {
        size = sizeNeeded;
        if (contents != NULL) {
            free(contents);
        }
        contents = calloc(size + 1, sizeof(char));
        sizeNeeded = GetIncludeContents(yytext,contents,size);
    }
    if (sizeNeeded <= 0) {
        free(contents);
        yyterminate();
    }
    else {
        yypush_buffer_state(YY_CURRENT_BUFFER);
        yy_scan_string(contents);
        free(contents);
        yylineno = 1;
        BEGIN(INITIAL);
    }
}

<INCLUDEFILE>.|\n {
    fprintf(stderr, "%4d bad include line\n", yylineno);
    yyterminate();
}


<<EOF>> {
    yypop_buffer_state();
    if ( !YY_CURRENT_BUFFER ) {
        yyterminate();
    }
}

\n { yylineno++; }

OPENQASM {
    yylval.svalue = AddString(yytext);
    return OPENQASM;
}

"//".*  {
}

CX {
    yylval.svalue = AddString(yytext);
    return CX;
}

U {
    yylval.svalue = AddString(yytext);
    return U;
}

-> {
    yylval.svalue = AddString(yytext);
    return ASSIGN;
}

== {
    yylval.svalue = AddString(yytext);
    return MATCHES;
}


[a-z][a-zA-Z0-9_]* {
    yylval.svalue = AddString(yytext);
    return ID;
}

[ \t\r] {
}

. {
    return yytext[0];
}

%%

int yywrap()
{
    return 1;
}

void yyerror(char *s)
{
    ParseFail(yylineno,s);
}

#pragma clang diagnostic pop
