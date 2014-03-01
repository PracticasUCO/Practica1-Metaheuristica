#! /usr/bin/env ruby -w

class TSP
	include Enumerable

	# caminos almacena los caminos almacenados de una ciudad a otra
	attr_reader :caminos

	# Numero de ciudades guardadas en la clase
	attr_reader :numero_ciudades

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
		raise TypeError, "path_db debe de ser un String" unless path_db.class.name == "String"

		@caminos = Array.new

		File.open(path_db, "r") do |f|
			# La primera linea nos da información acerca del numero de ciudades que hay
			# almacenadas en el fichero
			#
			# Nosotros lo guardamos para poder consultarlo rapidamente en el futuro a
			# traves del metodo TSP#numero_ciudades
			@numero_ciudades = f.gets.to_i

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

	# Accede a un elemento del la matriz de costes entre ciudades
	def [](index)
		@caminos[index]
	end

	# Iterador que accede a cada elemento de la matriz de costes
	def each
		@caminos.each do |ciudad|
			ciudad.each do |coste|
				yield coste
			end
		end
	end

	# Calcula el coste de una solucion dada
	#
	# Recibe como parametro un Array con las ciudades que se van a visitar
	def coste_solucion(ciudades)
		raise TypeError, "ciudades debe de ser un Array" unless ciudades.class.name == "Array"
		
		coste_actual = 0.0
		
		first = ciudades.each
		second = ciudades.each

		second.next

		loop do
			coste_actual += self[first][second]
		end

		coste_actual += self[ciudades[-1]][ciudades[0]]
		return coste_actual
	end

	# Constructor de la clase TSP. Recibe como argumento
	# el fichero del cual debe de leer la matriz de distancias
	def initialize(path_db)
		self.leer_intancia(path_db)
	end
end

a = TSP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/TSP/p01.txt")