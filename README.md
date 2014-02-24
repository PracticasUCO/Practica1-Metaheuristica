Practica1-Metaheuristica
========================

Este repositorio contiene la práctica 1 de la asignatura de metaheuristica realizada en la universidad de Córdoba, en el año académico 2013-2014

Se trata de implementar un programa que pueda realizar 4 ejecuciones diferentes:

- Resolución del problema de la diversidad maxima y minima

El problema de la maxima minima diversidad (MaxMin Diversity Problem, MMDP), consiste en
seleccionar un determinado numero de elementos de un conjunto de n elementos de tal forma
que la menor de las distancias entre los elementos seleccionados sea maxima. La definicion
distancia entre los elementos depende de las aplicaciones especificas.

Para resolver este problema se usaran dos tipos de instancias:
GKD-Ia: instancias del problema más sencillas de resolver por su pequeño tamaño
GKD-Ic: instancia más grande, requiriendo por ello mayor coste computacional

- El problema del viajante de comercio
Consiste en encontrar el camino más corto que une un conjunto de m ciudades de forma que ninguna
ciudad se visite dos veces y que se acabe en la misma ciudad en la que se empezo.

Se va a considerar la versión simetria del problema, es decir, aquella en la que la distancia
recorrida para ir de una ciudad i a una ciudad j es la misma que la distancia recorrida para
ir de la ciudad j a la ciudad i.

- Cutwidth problem
Dado un grafo no dirigido, el problema del minimizado del cutwidth problem consiste en encontrar una
ordenación no lineal del grafo de forma tal que el numero de aristas cortadas entre dos nodos consecutivos
sea minimo

- Capacited p-Hub
El problema del capacited p-hub (CPH) consiste en un conjunto de n centros que podr ́ıan tener
el rol de cliente o de concentrador (tambi ́en denominados hubs), de manera que:

- Se establece un numero maximo de centros que podrian ser concentradores igual a p.
- Todos los nodos son clientes, incluso los propios concentradores (que siempre estaran conectados a s si mismos).
- Cada cliente solo puede solicitar servicios de un concentrador.

El objetivo es seleccionar los p centros que actuaran como concentradores y decidir el concentrador de cada cliente, intentando minimizar la suma de las distancias de los clientes y de los concentradores.