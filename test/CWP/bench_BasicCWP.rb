#! /usr/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../../lib/CWP/BasicCWP/BasicCWP'

class Test_BasicCWPBenchmark < MiniTest::Benchmark
	def self.bench_range()
		path = `find . | grep instancias/P1/CWP/`.split(/\n/)
		return MiniTest::Benchmark.bench_linear(0, path.length - 1, 1)
	end
	
	def bench_solucion_aleatoria
		path = `find . | grep instancias/P1/CWP/`.split(/\n/)
		
		assert_performance_constant 0.99 do |index| # n is a range value
			b = CWP::BasicCWP.new(path[index])
			b.generar_solucion_aleatoria
		end
	end
end 
