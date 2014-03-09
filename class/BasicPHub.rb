#! /usr/bin/env ruby -w

require_relative 'CapacitedPHubNode'
require 'set'

=begin rdoc
La clase BasicPHub es la responsable de leer el fichero de base de datos
del problema proporcionado y conservar una representancion de todos
los nodos del problema.

Además de esto, debe dar un solución basica generada de forma aleatoria
=end
class BasicPHub
	# nodos guarda una representacion vectorial de todos los nodos
	# que hay en la base de datos. Estos nodos puede estar ya conectados
	# o no, dependiendo de si ha elegido conectarlos o no
	attr_reader :nodos
	
	# numero_concentradores indica el numero de concentradores que debe
	# de aparecer en la solucion
	attr_reader :numero_concentradores
	
	# Constructor de la clase BasicPHub, recibe como paremetro un
	# String que indica de donde leer la base de datos.
	def initialize(path_db)
		leer_instancia(path_db)
	end
	
	# Lee una instancia de la Base de datos y almacena todos los nodos
	# en su interior
	def leer_instancia(path_db)
		raise TypeError, "path_db debe de ser un string" unless path_db.kind_of? String
		
		@nodos.clear
		
		File.open(path_db, "r") do |file|
			# De la primera linea se lee el numero de nodos concentradores y
			# la capacidad por concentrador
			*, numero_concentradores, capacidad_concentrador = file.gets.split(/ +/)
			@numero_concentradores = numero_concentradores.to_i
			@capacidad_concentrador = capacidad_concentrador.to_f
			
			# Ahora se lee el resto del fichero
			file.each do |linea|
				linea = linea.chomp
				*, coorX, coorY, demanda = linea.split(/ +/)
				nodo = CapacitedPHubNode.new(coordenadas: [coorX, coorY], demanda: demanda, capacidad_servicio: capacidad_concentrador)
				@nodos << nodo
			end
		end
	end
end
