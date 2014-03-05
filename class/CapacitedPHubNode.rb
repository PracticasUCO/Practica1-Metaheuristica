#! /usr/bin/env ruby -w

=begin rdoc
La clase CapacitedPHubNode representa a un nodo de problema Capacited P Hub.
Un nodo estara representado por sus coordenadas, su demanda y si es
concentrador o no.

Las coordenadas indican la posicion del espacio donde se encuentra
el nodo.

La demanda del nodo indica que recursos demanda este cuando actua como
cliente.

Un nodo puede ser de dos tipos:
- Cliente, lo cual significa que necesita conectarse a otro nodo, denominado
 concentrador para poder realizar sus funciones
- Concentrador, es autosuficiente y puede realizar sus funciones, además
de recibir las peticiones de los demás nodos.

Cada nodo concentrador tiene ademas una capacidad maxima de servicio que
no puede ser sobrepasada
=end
