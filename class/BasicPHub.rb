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
	## El atributo numero_concentradores almacena el numero de concentradores
	## que deben de aparecer en la solucion
	attr_reader :numero_concentradores
	
	## El atributo clientes indica los nodos que actuan como clientes
	attr_reader :clientes
	
	## El atributo concentradores indica el numero de nodos que actuan
	## como concentradores
	attr_reader :concentradores
	
	## Constructor de la clase, recibe como parametro la ruta del
	## fichero que debe de leer
	def initialize(path)
		raise TypeError, "path must be a string" unless path.kind_of? String
		
		File.open(path, "r") do |file|
			# La primera linea contiene el numero de nodos totales que hay
			# el numero de nodos concentradores que debe haber y la capacidad
			# por concentrador maxima, que es la misma para todos los
			# concentradores. De aqui lo que no me sirve el numero de nodos
			# totales, por lo tanto no lo leo
			cabecera = file.gets
			*, numero_concentradores, capacidad_maxima_concentrador = cabecera.split(/ +/)
			numero_concentradores = numero_concentradores.to_i
			capacidad_maxima_concentrador = capacidad_maxima_concentrador.to_f
			
			@numero_concentradores = numero_concentradores
			@clientes = Set.new
			@concentradores = Set.new
			
			# Ahora procesamos el resto del fichero
			file.each do |linea|
				linea = linea.chomp
				*, coorX, coorY, demanda = linea.split(/ +/)
				nuevo = CapacitedPHubNode.new(coordenadas: [coorX, coorY], demanda: demanda, capacidad_servicio = capacidad_maxima_concentrador)
				@clientes << nuevo
			end
		end
	end
end
