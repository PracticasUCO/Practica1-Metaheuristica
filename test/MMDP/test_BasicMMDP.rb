#! /usr/bin/env ruby -w
# encoding: utf-8

require 'minitest/autorun'
require_relative '../../lib/MMDP/BasicMMDP/BasicMMDP'

class TestBasicMMDP < MiniTest::Test
	def setup
		@t = MMDP::BasicMMDP.new("instancias/P1/MMDP/GKD-Ia_59_n30_m9.txt")
	end
	
	def test_basic_params
		assert_equal(30, @t.total_nodes)
		assert_equal(9, @t.solution_nodes)
		assert_equal(30, @t.lista_nodos.length)
	end
	
	def test_solution
		sol, coste = @t.generar_solucion_aleatoria
		assert_equal(@t.solution_nodes, sol.length, "La solucion debe de tener exactamente #{@t.total_nodes}")
		assert_kind_of(Float, coste)
	end
	
	def test_aleatoriedad
		sol = Array.new
		repeticiones = 1000
		repeticiones.times do
			solucion, * = @t.generar_solucion_aleatoria
			sol << solucion
		end
		
		sol.uniq!
		assert_operator(sol.length, :>=, repeticiones*8/10)
	end

	def test_unicidad
		repeticiones = 1000

		repeticiones.times do
			solucion, * = @t.generar_solucion_aleatoria

			solucion.uniq!

			assert_operator(solucion.length, :==, @t.solution_nodes)
		end
	end
end