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
	attr_reader :max_nodes
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
				puts "Error de la base de datos"
				puts "Numero total de nodos: #{m}"
				puts "Numero maximo de nodos en la solucion: #{n}"
				puts ""
				puts "El numero maximo de nodos no puede ser mayor que el numero total de nodos"
				return
			end

			@total_nodes = m.to_i
			@max_nodes = n.to_i

			file.each do |linea|
				origen, destino, coste = linea.split(/ +/)
				signature = Array.new
				signature << origen << destino
				signature.sort!

				if not @nodes.has_key? signature
					@nodes[signature] = coste.to_f
				end
			end
		end
	end
end