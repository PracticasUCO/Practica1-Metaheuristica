#! /usr/bin/env ruby
# encoding: utf-8
require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../../lib/PHUB/BasicPHub/BasicPHub'

class BenchBasicPHub < MiniTest::Benchmark
	def self.bench_range
		paths = `find . | grep 'instancias/P1/CPH/'`.split(/\n/)
		MiniTest::Benchmark.bench_linear(0, paths.length - 1, 1)
	end
	
	def bench_generar_solucion
		paths = `find . | grep 'instancias/P1/CPH/'`.split(/\n/)
		
		assert_performance_constant 0.99 do |index|
			b = PHUB::BasicPHub.new(paths[index])
			b.generar_solucion_aleatoria
		end
	end
end
