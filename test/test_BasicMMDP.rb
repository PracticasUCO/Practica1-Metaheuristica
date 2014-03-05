#! /usr/bin/env ruby -w
 
require 'test/unit'
require_relative '../class/BasicMMDP'

class TestBasicMMDP < Test::Unit::TestCase
	def setup
		@t = BasicMMDP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/MMDP/GKD-Ia_59_n30_m9.txt")
	end
	
	def test_basic_params
		assert_equal(30, @t.total_nodes)
		assert_equal(9, @t.solution_nodes)
		assert_equal(29, @t.lista_nodos.length)
		assert_operator(@t.punto_ruptura, :>=, 1)
	end
	
	def test_solution
		sol, coste = @t.generar_solucion_aleatoria
		assert_equal(@t.solution_nodes, sol.length, "La solucion debe de tener exactamente #{@t.total_nodes}")
		assert_kind_of(Float, coste)
	end
	
	def test_aleatoriedad
		sol = Array.new
		1000.times do
			solucion, coste = @t.generar_solucion_aleatoria
			sol << solucion
		end
		
		sol.uniq!
		assert_operator(sol.length, :>=, 1000*4/5)
	end
end