#! /usr/bin/env ruby -w

require 'minitest/autorun'
require_relative '../class/BasicPHub'

class TestBasicPHub < MiniTest::Test
	def setup
		@t = BasicPHub.new("instancias/CPH/phub_50_5_1.txt")
	end
	
	def test_basic
		assert_equal(50, @t.nodos.length, "La base de datos leida debe de tener 50 nodos")
		assert_equal(5, @t.numero_concentradores, "Debe de haber 5 concentradores en la base de datos")
		assert_equal(120, @t.capacidad_concentrador)
	end
end
