require 'minitest/autorun'
require_relative '../../lib/PHUB/PHUB/PHUB'

class TestPHUB < MiniTest::Test
	def setup
		@t = PHUB::PHUB.new("instancias/P3/CPH/phub_100_10_1.txt")
	end
	
	def test_estacionario
		pretty, coste, solucion = @t.algoritmo_evolutivo_estacionario
		
		puts "Coste final entregado: #{coste}"
		
		assert_operator(coste, :<, 2000, "Se ha recibido un coste muy negativo.")
	end
end
