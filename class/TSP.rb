#! /usr/bin/env ruby -w

class TSP

	# Lee el fichero de BD y lo carga en memoria
	def leer_intancia(path_db)
		raise TypeError, "path_db debe de ser un String" unless path_db.class.name == "String"

		@caminos = Hash.new

		File.open(path_db, "r") do |f|
			# La primera linea nos da información acerca del numero de ciudades que hay
			# almacenadas en el fichero
			#
			# Aunque a priori el numero no no importa, ya que en Ruby no tenemos que
			# que hacer una reserva de memoria anticipada, si nos sirve para no leer toda
			# la base de datos, teniendo en cuenta que las distancias son simetricas
			max_ciudades = f.gets.to_i

			# Ahora podemos ir realizando una lectura completa del resto de la base de datos
			#
			# Uso el enumerador with_index para parar la ejecucion una vez que se haya leido
			# la mitad de la base de datos
			f.each_with_index do |linea, index|
				break unless index < max_ciudades / 2
				linea = linea.chomp
				ciudades = linea.split(/ +/)

				ciudades.each_with_index do |coste|

				end
			end
		end
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

	private :obtener_signature
end