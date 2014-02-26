#! /usr/bin/env ruby

=begin rdoc
La clase MMDP define una interfaz para el problema MMDP
propuesto en clase.
=end
class 
	attr_reader :total_nodes, :max_nodes
	# Constructor de MMDP. Recibe como parametro un string
	# con la direccion de la base de datos que se deseea leer
	def initialize(path_db)
		self.leerInstancia(path_db)
	end

	# Lee una base de datos nueva y la carga dentro del fichero
	def leerInstancia(path_db)
		@nodes = Hash.new
		File.open(path_db, "r") do |file|
			m, n = file.gets.chomp
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