#! /usr/bin/env ruby -w

require_relative '../CapacitedPHubNode/CapacitedPHubNode'
require_relative 'c_basic_phub'

=begin rdoc
La clase BasicPHub es la responsable de leer el fichero de base de datos
del problema proporcionado y conservar una representancion de todos
los nodos del problema.

Además de esto, debe dar un solución basica generada de forma aleatoria
=end
class BasicPHub
	# nodos guarda una representacion vectorial de todos los nodos
	# que hay en la base de datos. Estos nodos puede estar ya conectados
	# o no, dependiendo de si ha elegido conectarlos o no
	attr_reader :nodos
	
	# numero_concentradores indica el numero de concentradores que debe
	# de aparecer en la solucion
	attr_reader :numero_concentradores
	
	# Devuelve la capacidad de un concentrador, ya que todos tienen
	# la misma capacidad
	attr_reader :capacidad_concentrador
	
	# Constructor de la clase BasicPHub, recibe como paremetro un
	# String que indica de donde leer la base de datos.
	def initialize(path_db)
		@nodos = Array.new
		leer_instancia(path_db)
	end
	
	# Lee una instancia de la Base de datos y almacena todos los nodos
	# en su interior
	def leer_instancia(path_db)
		raise TypeError, "path_db debe de ser un string" unless path_db.kind_of? String
		
		@nodos.clear
		
		File.open(path_db, "r") do |file|
			# De la primera linea se lee el numero de nodos concentradores y
			# la capacidad por concentrador
			*, numero_concentradores, capacidad_concentrador = file.gets.split(/ +/)
			@numero_concentradores = numero_concentradores.to_i
			@capacidad_concentrador = capacidad_concentrador.to_f
			
			# Ahora se lee el resto del fichero
			file.each_with_index do |linea, index|
				next if linea.length.eql? 1
				linea = linea.chomp
				*, coorX, coorY, demanda = linea.split(/ +/)
				
				coorX = coorX.to_f
				coorY = coorY.to_f
				demanda = demanda.to_f
				#id = id.to_i
				
				nodo = CapacitedPHubNode.new(coordenadas: [coorX, coorY], demanda: demanda, capacidad_servicio: @capacidad_concentrador)
				
				@nodos << nodo
			end
		end
	end
	
	# La funcion objetivo devuelve la suma de las distancias de todos los nodos clientes a su concentrador
# 	def funcion_objetivo(solucion)
# 		raise TypeError, "La solucion debe de ser un Array de elementos" unless solucion.kind_of? Array
# 		
# 		suma = 0.0
# 		
# 		solucion.each do |nodo|
# 			raise RuntimeError, "Se ha pasado un elemento que no es un nodo a funcion objetivo.\n Elemento erroneo: #{nodo}" unless nodo.kind_of? CapacitedPHubNode
# 			solucion.each do |nodo_destino|
# 				next unless nodo_destino.tipo.eql? :cliente
# 				next if nodo_destino == nodo
# 			
# 				suma += nodo_destino.distancia(nodo)
# 			end
# 		end
# 		
# 		return suma/solucion.length
# 	end
	
	# Comprueba que se puede llegar a una solucion.
	# Devuelve true si es posible o false en caso contrario
	def solucion_factible?
		nodos_solucion = nodos.sort
		
		suma = 0
		
		numero_concentradores.times do
			nodos_solucion.delete_at(0)
		end
		
		nodos_solucion.each do |candidato|
			suma += candidato.demanda
		end
		
		suma /= numero_concentradores # Esto es así ya que todos los concentradores tiene la misma capacidad
		
		if suma > capacidad_concentrador
			return false
		else
			return true
		end
	end
	
	# Genera una solucion aleatoria
	def generar_solucion_aleatoria
		if solucion_factible?
			lista_de_nodos = nodos.dup
			concentradores = lista_de_nodos.sample(numero_concentradores)
			
			candidatos = lista_de_nodos.dup - concentradores
			
			# Se convierten los concentradores en concentradores
			concentradores.each do |concentrador|
				concentrador.tipo = :concentrador
			end
			
			# Se convierten los clientes en clientes
			candidatos.each do |cliente|
				cliente.tipo = :cliente
			end
			
			# Revuelvo la lista de candidatos para que se seleccionen
			# en orden aleatorio a la lista de concentradores
			candidatos.sort_by! {rand}
			
			concentradores.each do |concentrador|
				candidatos.each do |candidato|
					if not candidato.esta_conectado? and candidato.se_puede_conectar? concentrador
						candidato.conectar_a = concentrador
						concentrador.conectar_a = candidato
					end
				end
			end
			
			solucion = candidatos + concentradores
			
			coste = funcion_objetivo(solucion)
			
			solucion_texto = pretty_solution(solucion)
			
			return solucion_texto, coste, solucion
		else
			return Array.new, Float::INFINITY
		end
	end
	
	def pretty_solution(solucion)
		raise TypeError, "Solucion debe de ser un Array" unless solucion.kind_of? Array
		
		nueva_solucion = Array.new
		
		solucion.each do |nodo|
			nueva_solucion << "#{nodo.to_s}"
		end
		
		return nueva_solucion
	end
	
	private :funcion_objetivo, :pretty_solution
end
