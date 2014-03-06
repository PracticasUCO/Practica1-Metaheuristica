#! /usr/bin/env ruby -w
 
require 'test/unit'
require_relative '../class/CapacitedPHubNode'

class TestCapacitedPHubNode < Test::Unit::TestCase
	def setup
		@clientes = Array.new
		@concentradores = Array.new
		
		5.times do
			coordenadaX = rand(50)
			coordenadaY = rand(50)
			demanda = rand(15) + 5
			capacidad = rand(40) + 5

			client = CapacitedPHubNode.new(coordenadas: [coordenadaX, coordenadaY], demanda: demanda, capacidad_servicio: capacidad, tipo: :cliente)
			@clientes << client
		end
		
		3.times do
			coordenadaX = rand(50)
			coordenadaY = rand(50)
			demanda = rand(35) + 15
			capacidad = rand(40) + 5
			
			c = CapacitedPHubNode.new(coordenadas: [coordenadaX, coordenadaY], demanda: demanda, capacidad_servicio: capacidad, tipo: :concentrador)
			@concentradores << c
		end
		
		@clienteA = CapacitedPHubNode.new(coordenadas: [1, 3], demanda: 15.3, capacidad_servicio: 21, tipo: :cliente)
		@clienteB = CapacitedPHubNode.new(coordenadas: [5, 3], demanda: 13, capacidad_servicio: 22.1, tipo: :cliente)
		@concentradorA = CapacitedPHubNode.new(coordenadas: [5, 1], capacidad_servicio: 50, tipo: :concentrador)
		@concentradorB = CapacitedPHubNode.new(coordenadas: [4, 10], capacidad_servicio: 10, tipo: :concentrador)
	end
	
	def test_errores_constructor
		##  Comprobando el parametro coordenadas
		assert_raises(TypeError) {CapacitedPHubNode.new(coordenadas: 12)}
		assert_raises(TypeError) {CapacitedPHubNode.new(coordenadas: [1, 2, 3])}
		assert_raises(TypeError) {CapacitedPHubNode.new(coordenadas: ['a', 'b'])}
		
		## Comprobando el parametro demanda
		assert_raises(TypeError) {CapacitedPHubNode.new(demanda = 0)}
		assert_raises(TypeError) {CapacitedPHubNode.new(demanda = -5)}
		assert_raises(TypeError) {CapacitedPHubNode.new(demanda = "un valor cualquiera")}
		
		## Comprobando el parametro capacidad_servicio
		assert_raises(TypeError) {CapacitedPHubNode.new(capacidad_servicio: 0)}
		assert_raises(TypeError) {CapacitedPHubNode.new(capacidad_servicio: -5)}
		assert_raises(TypeError) {CapacitedPHubNode.new(capacidad_servicio: "5")}
		
		## Comprobando el parametro tipo
		assert_raises(TypeError) {CapacitedPHubNode.new(tipo: 1)}
		assert_raises(TypeError) {CapacitedPHubNode.new(tipo: rand)}
		assert_raises(TypeError) {CapacitedPHubNode.new(tipo: "cliente")}
		assert_raises(TypeError) {CapacitedPHubNode.new(tipo: :otro)}
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
	end
end