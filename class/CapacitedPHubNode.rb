#! /usr/bin/env ruby -w

require 'mathn'
require 'signal'

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
	include Signal
	
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
	# Demanda: 0
	# Tipo: :cliente
	# capacidad_servicio: 0
	#
	# Inicialmente todos los nodos estan desconectados, esto signifia que no podran funcionar
	# si son clientes hasta que se conecten a un concentrador
	def initialize(coordenadas: [0, 0], demanda: 1, tipo: :cliente, capacidad_servicio: 1)
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
	
	# Demanda devuelve la necesidad de recursos a ser atendidos por
	# el nodo cuando este actual de cliente
	def demanda
		raise RuntimeError, "Un nodo concentrador no tiene una demanda asociada" unless tipo.eql? :cliente
		@demanda
	end
	
	# capacidad_servicio devuelve la capacidad que tiene el nodo
	# para servir a los demas nodos cuando este actua de concentrador
	def capacidad_servicio
		raise RuntimeError, "Un nodo cliente no puede ofrecer ningun servicio" unless tipo.eql? :concentrador
		@capacidad_servicio
	end
	
	# tipo establece que tipo de nodo es el que se esta almacenando
	# puede ser de dos tipos:
	# :concentrador : une a distintos nodos clientes dandoles servicio
	# :cliente : para funcionar necesita conectarse a un nodo concentrador
	def tipo=(value)
		raise TypeError, "Value solo puede ser un Symbol con los valores :cliente o :concentrador" unless value.kind_of? Symbol
		raise TypeError, "El tipo debe de ser :cliente o :concentrador" unless value.=== :cliente or value.=== :concentrador
		
		desconectar
		
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
	
	# Establece a quien conectar el nodo
	def conectar_a=(other)
		raise TypeError, "other must be a CapacitedPHubNode" unless other.kind_of? CapacitedPHubNode
		raise TypeError, "un nodo no puede conectarse a si mismo" if self.eql? other
		raise TypeError, "Un concentrador solo pude conectarse a clientes y viceversa" if self.tipo.eql? other.tipo
		
		other.listeners << self unless other.listeners.include? self
		self.listeners << other unless self.listeners.include? other
		
		cancel_connection = false
		
		if tipo == :cliente
			antiguo = @connected[0]
			@connected.clear
			@connected << other
			emit(:delete_connection, self, antiguo)
		else
			unless @connected.include? other
				@connected << other
				@reserva -= other.demanda
				
				if reserva < 0
					emit(:delete_connection, self, other)
					@connected.delete(other)
					cancel_connection = true
				end
			end
		end
		
		emit(:add_nodo_connection, self, other) unless cancel_connection
	end
	
	# El siguiente metodo gestiona las conexiones entre nodos
	# destino es quien debe actualizar su tabla para que no
	# existan datos no concruentes
	def on_add_nodo_connection(origen, destino)
		if destino.=== self and not self.conectado_a.include? origen
			if tipo == :cliente
				antiguo = @connected[0]
				@connected.clear
				@connected << origen
				emit(:delete_connection, self, antiguo)
			else
				@connected << origen
				@reserva -= origen.demanda
				
				if reserva < 0
					emit(:delete_connection, self, origen)
					@connected.delete(origen)
				end
			end
		end
	end
	
	# El siguiente metodo gestiona las desconexiones de nodos
	def on_delete_connection(origen, destino)
		if destino === self
			@connected.delete(origen)
			
			if tipo == :concentrador
				@reserva += origen.demanda
			end
		end
	end
	
	## Desconecta el nodo de todos los demas nodos
	def desconectar
		@connected.each do |nodo|
			emit(:delete_connection, self, nodo)
		end
		@connected.clear
	end
	
	# Devuelve a quien esta conectado el nodo
	def conectado_a
		@connected
	end
	
end