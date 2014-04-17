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
	
	describe "Cuando se llama a PHUB#separar_nodos" do
		it "Debe de devolver dos vectores" do
			*, solucion = @t.generar_solucion_aleatoria
			
			a, b = @t.separar_nodos(solucion)
			
			a.must_be_kind_of Array
			b.must_be_kind_of Array
		end
		
		it "El primer vector debe de ser solo de concentradores" do
			*, solucion = @t.generar_solucion_aleatoria
		
			a, * = @t.separar_nodos(solucion)
			
			a.each do |nodo|
				nodo.tipo.must_equal :concentrador
			end
		end
		
		it "El segundo vector debe de ser solo de clientes" do
			*, solucion = @t.generar_solucion_aleatoria
		
			*, b = @t.separar_nodos(solucion)
			
			b.each do |nodo|
				nodo.tipo.must_equal :cliente
			end
		end
		
		it "El primer vector debe de tener una longitud igual al número de concentradores necesarios" do
			*, solucion = @t.generar_solucion_aleatoria
		
			a, * = @t.separar_nodos(solucion)
			
			a.length.must_equal @t.numero_concentradores
		end
	end
end
