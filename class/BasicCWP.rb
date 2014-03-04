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
	
	# Lee una instancia de la base de datos y la almacena internamente
	#
	# Recibe como parametro la localizacion de dicha instancia.
	# Este metodo cambia el contenido de :grafo
	def leer_instancia(path_db)
		raise TypeError, "path_db must be a string" if not path_db.kind_of? String
		
		@grafo = Hash.new(Array.new)
	end
end
