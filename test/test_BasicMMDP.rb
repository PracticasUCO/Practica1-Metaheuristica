#! /usr/bin/env ruby -w
 
require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../class/BasicMMDP'

class TestBasicMMDP < MiniTest::Test
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
		repeticiones = 1000
		repeticiones.times do
			solucion, coste = @t.generar_solucion_aleatoria
			sol << solucion
		end
		
		sol.uniq!
		assert_operator(sol.length, :>=, repeticiones*8/10)
	end
end

## Comprobación de la complejidad temporal
class TestBasicMMDPBenchmark < Minitest::Benchmark
	def setup
		@t = BasicMMDP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/MMDP/GKD-Ia_59_n30_m9.txt")
	end
	
	def bench_range
		Minitest::Benchmark.bench_exp(2, 2**20, 2)
	end
	
	def bench_solucion_aleatoria
		assert_performance_constant 0.9999 do |n|
			@t.generar_solucion_aleatoria
		end
	end
	
	def bench_constructor
		assert_performance_constant 0.9999 do |n|
			c = BasicMMDP.new("/home/gowikel/Practicas con Git/Practica1-Metaheuristica/instancias/MMDP/GKD-Ia_59_n30_m9.txt")
		end
	end
end