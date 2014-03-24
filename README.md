# Prácticas de Metaheurística
En este repositorio online voy a ir colgando las prácticas de Metaheurística realizadas en
la universidad de Córdoba en el curso academico 2013-2014

# Objetivos
Los objetivos de las prácticas de la asignatura son el aprendizaje de determinadas tecnicas
de programación que pueden proporcionar soluciones aceptables a problemas complejos para los
cuales las tecnicas estandar no pueden resolver en un tiempo computacional aceptable. Un
ejemplo de este tipo de problemas pueden ser todos aquellos de optimización combinatoria.

# Descripción de los problemas propuestos
Las prácticas constan de 4 problemas diferentes que han de resolverse usando algoritmos de
Monte Carlo o técnicas de metaheurística como búsqueda local y globla, enfriamiento simulado
y algoritmos evolutivos.

Los problemas propuestos son:
* Max Min Diversity Problem (MMDP)
* Travelling Salesman Problem (TSP)
* CutWidth Problem (CWP)
* PHub Problem (PHUB)

## El problema de maximizar la diversidad mínima (MMDP)
El problema Max Min Diversity Problem trata de escoger dentro de un determinado conjunto de individuos, un subconjunto de tamaño m, de manera que la diversidad entre cada uno de los individuos sea lo más grande
posible.

## El problema del viajante de comercio (TSP)
El problema del viajante de comercio (Travelling salesman problem), trata de establecer una ruta entre una serie de ciudades que cumpla con las siguientes condiciones:
* Se debe de escoger todas las ciudades integrantes del problema.
* Se debe empezar y acabar en la misma ciudad.
De entre todas las posibles soluciones al problema se debe escoger aquella ruta que tenga menor coste.

## El problema del ancho de corte (CWP)
El problema de la minimización del ancho de corte (CutWidth problem) es un problema NP-duro (Gavril 1977) y consiste en encontrar un diseño lineal de un grafo no dirigido, de manera que se reduzca al máximo el numero de
aristas consecutivas entre dos nodos.

## El problema del PHUB
El problema del P-hub es un problema de ubicación de las instalaciones que pueden ser visto como un tipo de problema de diseño de red. Cada nodo, dentro de un determinado conjunto de nodos, envía y recibe algo un tipo de tráfico hacia y desde los otros nodos. 

Los nodos concentradores deben ser elegidos entre estos nodos para actuar como puntos de conmutación para
el tráfico. Los enlaces de red se colocan entre pares de concentradores de manera que los centros están completamente interconectados. Cada uno de los nodos restantes, a su vez, está conectado a uno de los concentradores.

# Notas adicionales
Las prácticas de la asignatura de metaheurística se realizan de forma oficial C/C++, sin embargo yo las estoy
realizando en Ruby con permiso del profesor, entre otras cosas, porque queria aprovechar la oportunidad para
aprender este lenguaje de programación tan fascinante.

Al final, no solo estoy aprendiendo a programar en Ruby, sino que también estoy aprendiendo técnicas como
Test Driven Development que me ayudan a mejorar la calidad del código. 

Como ya he comentado, ni la universidad me enseña Ruby, ni yo sabía nada de Ruby antes de empezar estás
prácticas por lo que es posible que cometa errores en el diseño de programas, ruego que si van a revisar
el código me digan como mejorar y tengan paciencia.

Tampoco entra dentro de la asignatura el uso de herramientas de control de versiones como git, pero me
parecio buena idea usarla, especialmente debido a que estoy desarrollando toda la práctica en un unico lugar,
en lugar de hacer cientos de copias para guardar los cambios.

# Material academico usado
Bueno, como ya he comentado arriba, no sabía nada de Ruby antes de comenzar. Lo poco que se y que voy aprendiendo
es gracias a los siguintes libros:
* Pragmatic Programming Ruby 1.9 and 2.0 4th Edition by Dave Thomas
* Ruby best practices by Gregory T.Brown
* http://git-scm.com/documentation

Muchas gracias de antemano por tan excelentes libros, ya que explican de maravilla como adentrarse en profundidad
con Ruby.

También gracias al profesor Pedro A. Gutiérrez Peña por permitirme trabajar en este lenguaje.
