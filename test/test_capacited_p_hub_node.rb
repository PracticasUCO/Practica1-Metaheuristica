#! /usr/bin/env ruby -w
 
require 'minitest/autorun'
require_relative '../class/CapacitedPHubNode'

class TestCapacitedPHubNode < MiniTest::Test
	def setup
		@clientes = Array.new
		
		5.times do
			coordenadaX = rand(50)
			coordenadaY = rand(50)
			demanda = rand(15) + 5
			capacidad = rand(40) + 5

			client = CapacitedPHubNode.new(coordenadas: [coordenadaX, coordenadaY], demanda: demanda, capacidad_servicio: capacidad, tipo: :cliente)
			@clientes << client
		end
		
		@clienteA = CapacitedPHubNode.new(coordenadas: [1, 3], demanda: 15.3, capacidad_servicio: 21, tipo: :cliente)
		@clienteB = CapacitedPHubNode.new(coordenadas: [5, 3], demanda: 13, capacidad_servicio: 22.1, tipo: :cliente)
		@concentradorA = CapacitedPHubNode.new(coordenadas: [5, 1], capacidad_servicio: 50, tipo: :concentrador)
		@concentradorB = CapacitedPHubNode.new(coordenadas: [4, 10], capacidad_servicio: 10, tipo: :concentrador)
	end
	
	def test_errores_constructor
		##  Comprobando el parametro coordenadas
		assert_raises(TypeError, "El parametro coordenadas debe aceptar un array de dos numeros") {CapacitedPHubNode.new(coordenadas: 12)}
		assert_raises(TypeError, "El parametro coordenadas debe aceptar un array de dos numeros") {CapacitedPHubNode.new(coordenadas: [1, 2, 3])}
		assert_raises(TypeError, "El parametro coordenadas debe aceptar un array de dos numeros") {CapacitedPHubNode.new(coordenadas: ['a', 'b'])}
		assert_raises(TypeError, "El parametro coordenadas debe aceptar un array de dos numeros") {CapacitedPHubNode.new(coordenadas: ['a', 1])}
		assert_raises(TypeError, "El parametro coordenadas debe aceptar un array de dos numeros") {CapacitedPHubNode.new(coordenadas: [1, 'b'])}
		
		## Comprobando el parametro demanda
		assert_raises(TypeError, "La demanda debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(demanda: 0)}
		assert_raises(TypeError, "La demanda debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(demanda: -5)}
		assert_raises(TypeError, "La demanda debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(demanda: "other")}
		
		## Comprobando el parametro capacidad_servicio
		assert_raises(TypeError, "El servicio debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(capacidad_servicio: 0)}
		assert_raises(TypeError, "El servicio debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(capacidad_servicio: -5)}
		assert_raises(TypeError, "El servicio debe ser un numero positivo mayor que cero") {CapacitedPHubNode.new(capacidad_servicio: "5")}
		
		## Comprobando el parametro tipo
		assert_raises(TypeError, "El tipo solo puede ser :cliente o :concentrador") {CapacitedPHubNode.new(tipo: 1)}
		assert_raises(TypeError, "El tipo solo puede ser :cliente o :concentrador") {CapacitedPHubNode.new(tipo: rand)}
		assert_raises(TypeError, "El tipo solo puede ser :cliente o :concentrador") {CapacitedPHubNode.new(tipo: "cliente")}
		assert_raises(TypeError, "El tipo solo puede ser :cliente o :concentrador") {CapacitedPHubNode.new(tipo: :otro)}
	end
	
	def test_constructor_defecto
		default = CapacitedPHubNode.new
		other_default = CapacitedPHubNode.new(tipo: :concentrador)
		
		assert_equal([0,0], default.coordenadas)
		assert_equal(1, default.demanda)
		assert_equal(:cliente, default.tipo)
		assert_equal(:concentrador, other_default.tipo)
		assert_equal(1, other_default.capacidad_servicio)
	end
	
	def test_distancia
		d1 = @clienteA.distancia(@clienteB)
		d2 = @clienteB.distancia(@concentradorA)
		assert_equal(4, d1)
		assert_equal(2, d2)
		
		coordenadaX, coordenadaY = @clientes[0].coordenadas
		@clientes.each do |cliente|
			coordenadaX_cliente, coordenadaY_cliente = cliente.coordenadas
			distancia = Math.sqrt((coordenadaX - coordenadaX_cliente) ** 2 + (coordenadaY - coordenadaY_cliente) ** 2)
			assert_equal(distancia, @clientes[0].distancia(cliente))
		end
	end
	
	def test_demanda
		assert_raises(RuntimeError, "Un concentrador no tiene una demanda asociada") {@concentradorA.demanda}
		assert_equal(15.3, @clienteA.demanda)
	end
	
	def capacidad_servicio
		assert_raises(RuntimeError, "Un cliente no tiene una capacidad asociada") {@clienteA.capacidad_servicio}
		assert_equal(50, @concentradorA.capacidad_servicio)
	end
	
	def test_tipo
		assert_raises(TypeError, "El tipo solo puede ser :cliente o :concentrador") {@clienteA.tipo = :other}
		assert_equal(:cliente, @clienteA.tipo)
		@clienteA.tipo = :concentrador
		assert_equal(:concentrador, @clienteA.tipo)
	end
	
	def test_coordenadas
		assert_equal(2, @clienteA.coordenadas.length)
		assert_equal([1,3], @clienteA.coordenadas)
	end
	
	def test_conexion_basica
		assert_equal([], @clienteA.conectado_a, "Un nodo no se inicia con ninguna conexion")
		assert_raises(TypeError, "Un nodo solo puede conectarse a otro nodo") {@clienteA.conectado_a = "ads"}
		assert_raises(TypeError, "No se puede conectar dos clientes") {@clienteA.conectado_a = @clienteB}
		assert_raises(TypeError, "No se puede conectar un nodo a si mismo") {@clienteA.conectado_a = @clienteA}
		assert_raises(TypeError, "Un concentrador solo pude conectarse a clientes y viceversa") {@concentradorA.conectado_a = @concentradorB}
	end
end