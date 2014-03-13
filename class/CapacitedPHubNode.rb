#! /usr/bin/env ruby -w

require 'mathn'

=begin rdoc
La clase CapacitedPHubNode representa a un nodo de problema Capacited P Hub.
Un nodo estara representado por sus coordenadas, su demanda y si es
concentrador o no.

Las coordenadas indican la posicion del espacio donde se encuentra
el nodo.

La demanda del nodo indica que recursos demanda este cuando actua como
cliente.

Un nodo puede ser de dos tipos:
- Cliente, lo cual significa que necesita conectarse a otro nodo, denominado
 concentrador para poder realizar sus funciones
- Concentrador, es autosuficiente y puede realizar sus funciones, además
de recibir las peticiones de los demás nodos.

Cada nodo concentrador tiene ademas una capacidad maxima de servicio que
no puede ser sobrepasada
=end
class CapacitedPHubNode
	include Enumerable
	
	# cuenta_id es un atributo global que lleva la cuenta del proximo
	# id a establecer
	@@cuenta_id = 0
	
	# id es el numero de identificacion del nodo creado, este numero
	# es unico para cada nodo
	attr_reader :id
	
	# Coordenadas almacena las coordenadas en el plano del elemento
	attr_reader :coordenadas
	
	# La reserva es la cantidad de recursos que un nodo concentrador
	# pude seguir supliendo, teniendo en cuenta a los nodos clientes
	# que ya tiene conectados.
	attr_reader :reserva
	
	# capacidad_servicio devuelve la capacidad que tiene el nodo
	# para servir a los demas nodos cuando este actua de concentrador
	attr_reader :capacidad_servicio
	
	# demanda devuelve la necesidad de recursos de un nodo cuando
	# este actua como cliente
	attr_reader :demanda
	
	# id_concentrador devuelve el id del concentrador al que se conecto
	# por ultima vez un nodo como cliente
	attr_reader :id_concentrador
	
	# Constructor de nodo. Recibe como parametros
	# coordenadas: indica las coordenadas en el plano del vector, por
	# defecto en el (0,0)
	# 
	# demanda: Necesidad de recursos a ser satisfecha por un nodo cuando
	# actua como cliente
	#
	# tipo: Indica si el nodo es de tipo cliente o de tipo concentrador
	# valdra :cliente cuando sea lo primero y :concentrador cuando sea
	# lo segundo
	#
	# capacidad_servicio: Indica la cantidad de recursos maxima que puede
	# servir el nodo cuando actua como concentrador
	#
	#
	# Todos los parametros tiene valores por defecto, los cuales son:
	# Coordenadas: [0, 0]
	# Demanda: 1
	# Tipo: :cliente
	# capacidad_servicio: Infinita
	#
	# Inicialmente todos los nodos estan desconectados, esto signifia que no podran funcionar
	# si son clientes hasta que se conecten a un concentrador
	def initialize(coordenadas: [0, 0], demanda: 1, tipo: :cliente, capacidad_servicio: Float::INFINITY)
		raise TypeError, "Las coordenadas deben de ser un Array" unless coordenadas.kind_of? Array
		raise TypeError, "Solo se aceptan coordenadas del plano" unless coordenadas.length.eql? 2
		raise TypeError, "La demanda debe de ser un numero" unless demanda.kind_of? Numeric
		raise TypeError, "El cliente debe de ser de tipo Symbol" unless tipo.kind_of? Symbol
		raise TypeError, "El tipo debe de ser :cliente o :concentrador" unless tipo.eql? :cliente or tipo.eql? :concentrador
		raise TypeError, "La capacidad de servicio debe de ser un numero" unless capacidad_servicio.kind_of? Numeric
		
		raise TypeError, "La demanda debe de ser un numero positivo mayor que cero" unless demanda.> 0
		raise TypeError, "La capacidad del servicio debe de ser positiva mayor que cero" unless capacidad_servicio.> 0
		
		coordenadas.each do |coordenada|
			raise TypeError, "Las coordenadas deben ser valores numericos" unless coordenada.kind_of? Numeric
		end
		
		@coordenadas = coordenadas
		@demanda = demanda
		@tipo = tipo
		@capacidad_servicio = capacidad_servicio
		@connected = Array.new
		@reserva = capacidad_servicio
		
		# Estableciendo un id
		@id = @@cuenta_id
		@@cuenta_id += 1
	end

	# tipo establece que tipo de nodo es el que se esta almacenando
	# puede ser de dos tipos:
	# :concentrador : une a distintos nodos clientes dandoles servicio
	# :cliente : para funcionar necesita conectarse a un nodo concentrador
	def tipo=(value)
		raise TypeError, "Value solo puede ser un Symbol con los valores :cliente o :concentrador" unless value.kind_of? Symbol
		raise TypeError, "El tipo debe de ser :cliente o :concentrador" unless value.=== :cliente or value.=== :concentrador
		
		desconectar # Desconectamos al nodo de la red
		
		@tipo = value
		@reserva = @capacidad_servicio
	end
	
	# Devuelve el tipo de nodo, este valor se corresponde a :cliente o :concentrador
	def tipo
		@tipo
	end
	
	# Devuelve la distancia del nodo actual a otro nodo
	def distancia(other)
		raise TypeError, "other debe de ser otro CapacitedPHubNode" unless other.kind_of? CapacitedPHubNode
		otherX, otherY = other.coordenadas
		propiaX, propiaY = coordenadas
		Math.sqrt(((otherX - propiaX) ** 2) + ( (otherY - propiaY ) ** 2 ))
	end
	
	# Establece a quien conectar el nodo. Ojo que no se comprueba que la conexion no sature
	# a un concentrador. Es responsabilidad del encargado de la conexion de verificar los fallos
	# La conexion siempre se efectua, al no ser que se intenten conectar dos nodos del mismo tipo
	# o se mande un parametro no correcto. En caso de error se levanta una excepcion del tipo TypeError
	def conectar_a=(other)
		raise TypeError, "other must be a CapacitedPHubNode" unless other.kind_of? CapacitedPHubNode
		raise TypeError, "un nodo no puede conectarse a si mismo" if self.eql? other
		raise TypeError, "Un concentrador solo pude conectarse a clientes y viceversa" if self.tipo.eql? other.tipo
		
		if tipo == :cliente
			desconectar # Nos desconectamos del nodo al que estuviesemos conectados
			@connected << other
			@id_concentrador = other.id
		else
			unless conectado_a(other)
				@connected << other
				@reserva -= other.demanda
			end
		end
	end
	
	# Devuelve a quien esta conectado el nodo.
	# Si no recibe parametros devuelve la lista de nodos a las que se encuentra conectado.
	# En caso contrario, devuelve si esta conectado a cada uno de los nodos de la lista
	def conectado_a(*other)
		if other.length == 0
			@connected
		else
			resultado = false
			other.each do |nodo|
				raise TypeError, "Todos los parametros de conectado_a deben de ser nodos" unless nodo.kind_of? CapacitedPHubNode
				
				if @connected.include? nodo
					resultado = true
				else
					resultado = false
					break
				end
			end
			return resultado
		end
	end
	
	# Permite convertir el nodo a cadena para que se pueda leer mejor
	def to_s
		if tipo === :concentrador
			"Concentrador nodo #{id} en #{coordenadas} con #{reserva}/#{capacidad_servicio} (#{(100*reserva/capacidad_servicio).to_i} %)"
		else
			"Cliente nodo #{id} en #{coordenadas} con una demanda de #{demanda}."
		end
	end
	
	# Se compara con otro metodo
	def <=>(other)
		self.id.<=> other.id
	end
	
	# Comprueba si se puede conectar a otro nodo
	# Recibe como parametro un nodo CapacitedPHubNode
	def se_puede_conectar?(other)
		raise TypeError, "other debe de ser un nodo" unless other.kind_of? CapacitedPHubNode
		
		if other.tipo == tipo
			return false
		else
			if other.tipo == :concentrador
				return other.reserva >= demanda
			else
				return reserva >= other.demanda
			end
		end
	end
	
	# Indica si el nodo esta conectado o no. Devuelve true si
	# el nodo esta conectado a algun otro nodo o false en caso
	# contrario
	def esta_conectado?
		if conectado_a.length == 0
			false
		else
			true
		end
	end
	
	# Desconecta completamente el nodo
	def desconectar
		@connected.clear
	end
	
end