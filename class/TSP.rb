#! /usr/bin/env ruby -w

class TSP

	# caminos almacena los caminos almacenados de una ciudad a otra
	attr_reader :caminos

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
		raise TypeError, "path_db debe de ser un String" unless path_db.class.name == "String"

		@caminos = Array.new

		File.open(path_db, "r") do |f|
			# La primera linea nos da información acerca del numero de ciudades que hay
			# almacenadas en el fichero
			#
			# Dicho valor no nos importa a priori, por lo que no lo guardamos
			f.gets

			# Ahora podemos ir realizando una lectura completa del resto de la base de datos
			#
			# Uso el enumerador with_index para parar la ejecucion una vez que se haya leido
			# la mitad de la base de datos
			f.each_with_index do |linea, index|
				fila_costes = linea.chomp.split(/ +/)
				
				#Convertimos la fila de string a flotante
				fila_costes.each_with_index {|coste, index| fila_costes[index] = coste.to_f}

				#Añadimos la fila completa al array
				@caminos << fila_costes
			end
		end
	end

	# Constructor de la clase TSP. Recibe como argumento
	# el fichero del cual debe de leer la matriz de distancias
	def initialize(path_db)
		self.leer_intancia(path_db)
	end
end

a = TSP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/TSP/p01.txt")