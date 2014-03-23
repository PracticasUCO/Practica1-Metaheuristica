#! /usr/bin/env ruby -w
# encoding: utf-8

require 'minitest/autorun'
require_relative '../lib/PHUB/BasicPHub/BasicPHub'

class TestBasicPHub < MiniTest::Test
	def setup
		@t = PHUB::BasicPHub.new("instancias/P1/CPH/phub_50_5_1.txt")
	end
	
	def test_basic
		assert_equal(50, @t.nodos.length, "La base de datos leida debe de tener 50 nodos")
		assert_equal(5, @t.numero_concentradores, "Debe de haber 5 concentradores en la base de datos")
		assert_equal(120, @t.capacidad_concentrador)
	end
	
	def test_numero_concentradores_solucion
		numero_concentradores = 0
		*, coste, solucion = @t.generar_solucion_aleatoria
		
		solucion.each do |nodo|
			numero_concentradores += 1 if nodo.tipo.eql? :concentrador
		end
		
		if coste != Float::INFINITY
			assert_equal(5, numero_concentradores, "El numero de concentradores de la solucion es incorrecto")
		end
	end
	
	def test_conexiones_solucion_completo
		paths = `find . | grep 'instancias/CPH/'`.split(/\n/)
		
		paths.each do |path|
			t = PHUB::BasicPHub.new(path)
			*, solucion = t.generar_solucion_aleatoria
			concentradores = Array.new
			clientes = Array.new
			conectado = 0
			sin_conectar = Array.new
			
			solucion.each do |nodo|
				if nodo.tipo == :concentrador
					concentradores << nodo
				else
					clientes << nodo
					
					if nodo.esta_conectado?
						conectado += 1
					else
						sin_conectar << nodo
					end
				end
			end
			
			assert_operator(conectado, :>=, (@t.nodos.length - @t.numero_concentradores) * 0.9)
			
			sin_conectar.each do |candidato|
				concentradores.each do |concentrador|
					assert_operator(candidato.demanda, :>, concentrador.reserva)
				end
			end
		end
		
	end
	
	def test_conexiones_completo
		*,solucion = @t.generar_solucion_aleatoria
		
		solucion.each do |nodo|
			if nodo.tipo == :cliente
				if nodo.esta_conectado?
					concentrador = nodo.conectado_a().pop
					assert_equal(true, concentrador.conectado_a(nodo), "Debe de haber una conexion mutua entre los nodos")
				end
			end
		end
	end
	
	def test_aleatoriedad
		soluciones = Array.new
		repeticiones = 40
		
		repeticiones.times do
			*, solucion = @t.generar_solucion_aleatoria
			soluciones << solucion
		end
		
		soluciones.uniq!
		
		assert_operator(soluciones.length, :>=, (0.75 * repeticiones))
	end
end