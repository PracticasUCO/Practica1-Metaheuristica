#! /usr/bin/env ruby -w

require_relative 'c_basic_tsp'

# En el modulo TSP se encuentran todas las clases pertenecientes al problema
# del TSP
module TSP

	# La clase BasicTSP trata de resolver el problema del viajante de comercio.
	# En este problema, se tiene una serie de ciudades que deben de ser visitadas
	# de manera que se empiece y se acabe en la misma ciudad. El problema consiste
	# en elegir como se visitaran tales ciudades de manera que el coste de
	# transitar por ellas sea el menor posible.
	#
	# Se asume para esta implementación que el coste entre dos ciudades
	# cualesquiera es simétrica, es decir, el coste de ir desde A hasta B debe ser
	# el mismo que el coste de ir desde B hasta A
	class BasicTSP
		include Enumerable

		# caminos almacena los caminos almacenados de una ciudad a otra
		attr_reader :caminos

		# Numero de ciudades guardadas en la clase
		attr_reader :numero_ciudades

		# Lee el fichero de BD y lo carga en memoria
		def leer_intancia(path_db)
			raise TypeError, "path_db debe de ser un String" unless path_db.kind_of? String

			@caminos = Array.new

			File.open(path_db, "r") do |f|
				# La primera linea nos da información acerca del numero de ciudades que hay
				# almacenadas en el fichero
				#
				# Nosotros lo guardamos para poder consultarlo rápidamente en el futuro a
				# través del método TSP#numero_ciudades
				@numero_ciudades = f.gets.to_i

				# Ahora podemos ir realizando una lectura completa del resto de la base de datos
				f.each do |linea|
					fila_costes = linea.chomp.split(/ +/)
					
					#Convertimos la fila de string a flotante
					fila_costes.map! {|coste| coste.to_f}

					#Añadimos la fila completa al array
					@caminos << fila_costes
				end
			end
		end

		# Genera una solución aleatoria al problema del
		# viajante del comercio
		def generar_solucion_aleatoria
			ciudades = Array.new(numero_ciudades) {|index| index}
			solucion = ciudades.sample(ciudades.length)
			coste = coste_solucion(solucion)

			return solucion, coste
		end

		# Constructor de la clase TSP. Recibe como argumento
		# el fichero del cual debe de leer la matriz de distancias
		def initialize(path_db)
			self.leer_intancia(path_db)
		end

		private :coste_solucion
	end
end
