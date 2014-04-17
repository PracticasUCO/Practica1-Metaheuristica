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
		@t = PHUBPrivate.new("instancias/P3/CPH/phub_100_10_1.txt")
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
	
	describe "Cuando se realiza un torneo" do
		before do
			@t = PHUBPrivate.new("instancias/P3/CPH/phub_100_10_1.txt")
			@lista = Array.new
			@costes = Hash.new
			
			50.times do
				*, coste, solucion = @t.generar_solucion_aleatoria
				
				@lista << solucion
				@costes[solucion] = coste
			end
		end
		
		it "Si se seleccionan menos soluciones que el número de aspirantes no puede haber soluciones repetidas" do
			30.times do
				ganadores = rand(48) + 2
				
				seleccionados = @t.torneo(@lista, @costes, ganadores)
				
				seleccionados.uniq!
				
				seleccionados.length.must_equal ganadores
			end
		end
		
		it "Si se intentan seleccionar el mismo número de aspirantes que soluciones se devuelve una copia de las soluciones" do
			seleccionados = @t.torneo(@lista, @costes, 50)
			seleccionados.must_equal @lista
		end
		
		it "Si se seleccionan más aspirantes que concursantes habra soluciones repetidas" do
			seleccionados = @t.torneo(@lista, @costes, 125)
			
			seleccionados.length.must_equal 125
		end
	end
end
