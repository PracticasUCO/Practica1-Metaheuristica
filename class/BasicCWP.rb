#! /usr/bin/env ruby -w

class BasicCWP
	# El atributo grafo guarda una tabla de hash con cada
	# uno de los nodos del grafo. La tabla usara como
	# llave el nodo del grafo, y el valor que devolvera sera
	# un vector con todas las posiciones a las que se puede
	# ir a partir de dicho nodo
	attr_reader :grafo
	
	# Constructor de BasicCWP. Recibe como parametro la localizacion
	# del archivo de texto que debe de leer para cargar la base
	# de datos.
	def initialize(path_db)
		leer_instancia(path_db)
	end
end
