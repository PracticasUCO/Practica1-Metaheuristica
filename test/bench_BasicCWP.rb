require 'minitest/benchmark'
require_relative '../class/BasicCWP'

class Test_BasicCWPBenchmark < MiniTest::Benchmark
	def self.bench_range()
		path = `find . | grep instancias/CWP/`.split(/\n/)
		return MiniTest::Benchmark.bench_linear(0, path.length - 1, 1)
	end
	
	def bench_solucion_aleatoria
		path = `find . | grep instancias/CWP/`.split(/\n/)
		
		assert_performance_constant 0.9999 do |index| # n is a range value
			b = BasicCWP.new(path[index])
			b.generar_solucion_aleatoria
		end
	end
end 
