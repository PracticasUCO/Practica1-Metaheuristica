#! /usr/bin/env ruby

require 'minitest/autorun'
require_relative '../../lib/PHUB/PHUB/PHUB'

# Esta clase servira para probar los metodos privados
# de la clase PHUB
class PHUBPrivate < PHUB
	public :random_number, :separar_nodos, :torneo, :torneo_injusto, :ruleta, :seleccion, :cruce
end

class TestPrivate < Minitest::Test
	def setup
		@t = PHUB::PHUB.new("instancias/P1/CPH/phub_50_5_1.txt")
	end
end
