#! /usr/bin/env ruby
# encoding: utf-8

require 'minitest/autorun'
require 'minitest/benchmark'
require_relative '../lib/MMDP/BasicMMDP/BasicMMDP'

class BenchBasicMMDP < MiniTest::Benchmark
	def self.bench_range
		paths = `find . | grep 'instancias/P1/MMDP/'`.split(/\n/)
		MiniTest::Benchmark.bench_linear(0, paths.length - 1, 1)
	end
	
	def bench_solucion_aleatoria
		paths = `find . | grep 'instancias/P1/MMDP/'`.split(/\n/)
		
		assert_performance_constant 0.9999 do |index|
			b = MMDP::BasicMMDP.new(paths[index])
			b.generar_solucion_aleatoria
		end
	end
end
