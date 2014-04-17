#! /usr/bin/env ruby

require_relative '../../lib/PHUB/PHUB/PHUB'
require 'minitest/autorun'

# Esta clase servira para probar los metodos privados
# de la clase PHUB
class PHUBPrivate < PHUB::PHUB
	public :random_number, :separar_nodos, :torneo, :torneo_injusto, :ruleta, :seleccion
end

describe PHUBPrivate do
	before do
		@t = PHUBPrivate.new("instancias/P1/CPH/phub_50_5_1.txt")
	end
end
