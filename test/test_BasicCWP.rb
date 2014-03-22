#! /usr/bin/env ruby
# encoding: utf-8

require 'minitest/autorun'
require_relative '../class/CWP/BasicCWP/BasicCWP'

class TestBasicCWP < MiniTest::Test
	
	# Agradeceria que alguien me ayudara a reemplazar esto con algo que no dependiera de mi
	# maquina actual.
	def setup
		@c = BasicCWP.new("instancias/P1/CWP/ejemplo.txt")
	end
	
	def test_total_nodes
		assert_equal(6, @c.total_nodes)
		assert_equal(7, @c.total_aristas)
	end
	
	def test_lectura
		refute_empty(@c.grafo)
	end
	
	def test_numero_nodos_solucion
		sol, cos = @c.generar_solucion_aleatoria
		assert_equal(@c.total_nodes, sol.length)
		assert_operator(cos, :>, 0)
	end
	
	def test_grafo
		grafo = @c.grafo
		grafo_test = {"1" => ["2","5","4"],"2" => ["1","3"],"3" => [2],"4" => ["1","5","6"],"5" => ["1","4","6"],"6" => ["4","5"]}
		
		for key, value in grafo_test
			vector_nodos = grafo[key]
			assert_equal(value.length, vector_nodos.length, "El nodo #{key} deberia de tener #{value.length} aristas.")
			
			value.each do |nodo_original|
				assert_includes(vector_nodos, nodo_original.to_s)
			end
		end
	end
	
	def test_aleatoriedad
		soluciones = Array.new
		repeticiones = 240
		repeticiones.times do
			solucion, coste = @c.generar_solucion_aleatoria
			soluciones << solucion
		end
		soluciones.uniq!
		
		assert_operator(soluciones.length, :>, repeticiones*7/10)
	end
end
