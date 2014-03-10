require 'minitest/benchmark'
require_relative '../class/BasicTSP'

class BenchBasicTSP < MiniTest::Benchmark
	def self.bench_range
		paths = `find . | grep 'instancias/TSP/'`.split(/\n/)
		MiniTest::Benchmark.bench_linear(0, paths.length - 1, 1)
	end
	
	def bench_solucion_aleatoria
		paths = `find . | grep 'instancias/TSP/'`.split(/\n/)
		
		assert_performance_constant 0.99 do |index|
			b = BasicTSP.new(paths[index])
			b.generar_solucion_aleatoria
		end
	end
end
