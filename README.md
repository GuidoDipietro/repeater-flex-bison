# Repeater
Un lenguaje de programación extremadamente simple que no tiene ninguna utilidad.  
<img src="https://i.kym-cdn.com/photos/images/original/001/383/953/0c2.jpeg" width=200 height=200>

<hr>

# ¿¿Por qué??
Quería practicar Bison.

# Variables
En *Repeater* las variables solamente pueden guardar *repetidores*, y solamente pueden ser llamadas mediante el comando `print` para que hagan lo que mejor saben hacer: _repetir una salida hasta el hartazgo._
Ejemplo:  
```C
molesto = repeat { "hola" } 14
print molesto
// imprime "hola" catorce veces en pantalla
```

# Listas numéricas
Pero hay más. El comando `repeat` no funciona solo con un número _así nomás_, sino que acepta cualquier tipo de dato numérico.  
Como este lenguaje no sirve para nada, la única otra manera de conseguir un número es mediante el comando `sum` sumando una lista.    
Ejemplo:
```C
{sum {11,2,1}}                  // se evalúa como 11+2+1 = 14
{sum {,  ,,1,,}}                // se evalúa como 0+0+0+1+0+0 = 1
{sum { { 1,1 }, {} , 1 , 24 } } // lista de dos listas + dos números
                                // se evalúa como (1+1)+(0)+1+24 = 27
```

En definitiva, las listas pueden contener números (enteros positivos que no empiecen con `0`), listas, y cualquier cosa que sea un caracter blanco o vacío se ignora (en realidad, en algunos casos se suma `0` al total).

Entonces, otro ejemplo del comando `repeat` puede ser el siguiente:  
```C
enojado = repeat { "no" } { sum { 1 , {2,,} , {} , 14 } }
// el sum se evalúa como 1+(2+0+0)+(0)+14 = 17
print enojado
// imprime "no" 17 veces
```

O si solamente queremos ver el resultado de un `sum`:
```C
print { sum {14,27,49} }
// imprime 90
print { sum {{{,,,{},{},{{{{{{{{},{},{}}}}}}}}}}} }
// imprime 0 (fijate, están todos bien los corchetes)
print { sum { { { ,,,{},{},{{{{{{{{},{},{}}}}}}}} } } }
// se queda esperando porque falta un corchete; si ponés } imprime 0
```

# Tokens
Este lenguaje tiene en total 10 tokens, que son los siguientes:

### Palabras reservadas
- `print`
- `sum`
- `repeat`

### Caracteres de puntuación
- `{` y `}` (para delimitar listas, o ejecutar los comandos `sum` y `repeat`)
- `,` (para separar los elementos dentro de las listas)
- `=` (para asignar información a una variable)

### Identificadores, constantes, y cadenas
- Identificadores: `[a-zA-Z]+` (una letra o más, pueden ser mayúsculas o minúsculas)
- Constantes: `[1-9][0-9]*` (cualquier entero positivo que no empiece con `0`)
- Cadenas: `\"[a-zA-Z]*\"` (cero o más letras mayúsculas o minúsculas entre comillas dobles)

Los espacios, tabulaciones, o nuevas líneas se ignoran.

# Compilar
Compilar ejecutando los siguientes comandos:
```
flex repeater.l
bison -yd repeater.y
gcc lex.yy.c y.tab.c -o repeater
```
O bien ejecutando el batchfile `compilar.bat` que hace lo mismo.

# Ejecutar
Para usarlo en consola, solamente hay que ejecutar el archivo `repeater.exe` que se generará tras compilar los archivos de Flex y Bison (o solo `repeater` en algunos SOs), y jugar allí.

Para ejecutar un programa contenido en un archivo, por lo pronto hacerlo de la siguiente manera:  

- Crear un archivo llamado `programa.rpt` (cualquier nombre, o usar el que subí como ejemplo)
- Ejecutar `repeater < programa.rpt`
- Sonreír