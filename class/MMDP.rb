#! /usr/bin/env ruby

=begin rdoc
La clase MMDP define una interfaz para el problema Max Min Diversity Problem
propuesto en clase.
=end
class MMDP
	# El atributo total_nodes indica el numero total de nodos que
	# hay en la base de datos
	attr_reader :total_nodes 

	# El atributo max_nodes indica el numero maximo de nodos
	# que debe aparecer en la solucion
	attr_reader :solution_nodes
	
	# Constructor de MMDP. Recibe como parametro un string
	# con la direccion de la base de datos que se deseea leer
	def initialize(path_db)
		self.leerInstancia(path_db)
	end

	# Lee una base de datos nueva y la carga dentro del fichero
	def leerInstancia(path_db)
		@nodes = Hash.new

		File.open(path_db, "r") do |file|
			m, n = file.gets.chomp.split(/ +/)

			if n.to_i > m.to_i
				error_string = <<-END_ERROR
				Error en la base de datos
				Numero total de nodos: #{m}
				Numero maximo de nodos: #{n}

				El numero maximo de nodos no puede ser mayour que
				el numero total de nodos.

				No se puede continuar
				END_ERROR
				error_string.gsub!(/\t/, "")

				raise error_string
			end

			@total_nodes = m.to_i
			@solution_nodes = n.to_i

			file.each do |linea|
				origen, destino, coste = linea.split(/ +/)
				signature = Array.new
				signature << origen << destino
				signature.sort!

				@nodes[signature] = coste.to_f if not @nodes.has_key? signature
			end
		end
	end

	# Genera una solución aleatoriamente a partir de la base de datos
	# que se ha leido previamente. La solucion generada trata que
	# el coste sea el maximo posible. 
	# 
	# Devuelve un vector con los nodos
	# seleccionados y un valor flotante con la suma de costes
	def generarSolucionAleatoria()
	end
end

m = MMDP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/MMDP/GKD-Ia_1_n10_m2.txt")