#! /usr/bin/env ruby -w

class TSP

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
		raise TypeError, "path_db debe de ser un string" unless path_db.class.name == "String"
		@lista_ciudades = Array.new
		@caminos = Hash.new

		File.open(path_db, "r") do |f|
			# La primera lectura corresponde al numero total de ciudades
			# que en nuestro caso no no interesa saber a priori, ya que
			# no tenemos los mismo problemas que un programa en C, así
			# que la descartamos.
			#
			# Aun con todo, como la matriz es simetrica, usaremos dicho
			# valor para solo tratar de leer la mitad de la matriz
			max_ciudades = f.gets.to_i


			f.each do |linea|
			end
		end
	end

	# Constructor de la clase TSP. Recibe como argumento
	# el fichero del cual debe de leer la matriz de distancias
	def initialize(path_db)
		self.leer_intancia(path_db)
	end
end