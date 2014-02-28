#! /usr/bin/env ruby -w

class TSP

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
	end

	# Constructor de la clase TSP. Recibe como argumento
	# el fichero del cual debe de leer la matriz de distancias
	def initialize(path_db)
		self.leer_intancia(path_db)
	end

	# Devuelve la llave de hash asociada a dos ciuades que se
	# pasen como argumento
	def obtener_signature(ciudad_a, ciudad_b)
		raise TypeError, "ciudad_a debe de ser un String" unless ciudad_a.class.name == "String"
		raise TypeError, "ciudad_b debe de ser un String" unless ciudad_b.class.name == "String"

		signature = Array.new
		signature << ciudad_a << ciudad_b
		signature.sort!
	end
end