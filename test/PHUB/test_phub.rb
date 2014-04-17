#! /usr/bin/env ruby

require_relative '../../lib/PHUB/PHUB/PHUB'
require 'minitest/autorun'

# Esta clase servirá para probar los métodos privados
# de la clase PHUB
class PHUBPrivate < PHUB::PHUB
	public :random_number, :separar_nodos, :torneo, :torneo_injusto, :ruleta, :seleccion
end

describe PHUBPrivate do
	before do
		@t = PHUBPrivate.new("instancias/P1/CPH/phub_50_5_1.txt")
	end
	
	describe "Cuando se llama a random_number" do
		it "Debe de devover un número entre 0-1" do
			300.times do
				numero_generado = @t.random_number
				
				numero_generado.must_be :<=, 1
				numero_generado.must_be :>=, 0
			end
		end
	end
end
