%{

void yyerror(char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

// tipo de dato de la tabla de simbolos
typedef struct {
	char* id;
	char* str;
	int num;
} repeatype;

repeatype symbols[100];				// tabla de simbolos, tenes 100 para divertirte
repeatype symbolVal(char* symbol);	// para leer de la TS
void updateSymbolVal(char* symbol, char* s, int n); // para escribir a la TS

%}

%union {
	int num;
	char* str;
	char* id;
}

%token REPEAT PRINT SUM
%token LEFTCURLY RIGHTCURLY EQ
%left COMMA
%token <num> NUMBER
%token <str> STRING
%token <id> ID
%type <num> numlist numseq sum numerical

%%

linea 	: show
		| save
		| linea show
		| linea save
;

show	: PRINT ID 							{
			repeatype r = symbolVal($2); // leyendo de la TS
			// Mostrando la cadena N veces
			printf("\n");
			for (int i=0; i<r.num; i++) {
				printf("%s\n", r.str);
			}
			printf("\n");
		}
		| PRINT sum 						{ printf("%d\n", $2); }
;

save	: ID EQ REPEAT LEFTCURLY STRING RIGHTCURLY numerical {
			// Guardando el valor a la TS
			updateSymbolVal($1, $5, $7);
		}
;

numerical 	: NUMBER
			| sum
;

sum		: LEFTCURLY SUM numlist RIGHTCURLY			{ $$ = $3; }
;

numlist : LEFTCURLY numseq RIGHTCURLY				{ $$ = $2; }
;

numseq	:								{ $$ = 0;} /* toma la cadena vacia como 0 */
		| NUMBER
		| numlist
		| numseq COMMA numseq			{ $$ = $1 + $3; }
;

%%

repeatype symbolVal(char* symbol){
	// ineficiente, lo se, no pense mucho.
	int i = 0;
	repeatype out;

	while(strcmp(symbols[i].id, symbol)) i++; // aumenta i hasta llegar al struct con id=symbol
	out.str = symbols[i].str;  	// Copia el puntero, no se si conviene esto o strdup() pero ya fue
	out.id = symbols[i].id;		// lo mismo
	out.num = symbols[i].num;

	return out;
}

void updateSymbolVal(char* symbol, char* s, int n){
	// ineficiencia parte 2
	int i = 0;

	for (i; symbols[i].num==0; i++)
		; // forma graciosa de escribir un while, porque tenia ganas
	symbols[i].num = n;
	symbols[i].str = strdup(s);
	symbols[i].id = strdup(symbol);
}

int main(){
	// Inicializando la Tabla de Simbolos, bien barato
	for(int i=0; i<100; i++){
		symbols[i].num=0;
		symbols[i].id = strdup("");
		// symbols[i].str no nos importa mucho para esto, podria inicializarlo
		// en la cadena vacia por prolijidad pero ya fue x 2
	}
	return yyparse();
}

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
} 