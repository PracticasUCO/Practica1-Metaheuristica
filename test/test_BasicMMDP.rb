#! /usr/bin/env ruby -w
 
require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../class/BasicMMDP'

class TestBasicMMDP < MiniTest::Test
	def setup
		@t = BasicMMDP.new("instancias/MMDP/GKD-Ia_59_n30_m9.txt")
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
			solucion, * = @t.generar_solucion_aleatoria
			sol << solucion
		end
		
		sol.uniq!
		assert_operator(sol.length, :>=, repeticiones*8/10)
	end
end

class BenchBasicMMDP < MiniTest::Benchmark
	def self.bench_range
		paths = `find . | grep 'instancias/MMDP/'`.split(/\n/)
		MiniTest::Benchmark.bench_linear(0, paths.length - 1, 1)
	end
	
	def bench_solucion_aleatoria
		paths = `find . | grep 'instancias/MMDP/'`.split(/\n/)
		
		assert_performance_constant 0.9999 do |index|
			b = BasicMMDP.new(paths[index])
			b.generar_solucion_aleatoria
		end
	end
end