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
		
		it "Siempre gana aquella solución con mejor fitness" do
			coste_a = nil
			coste_b = nil
			
			while coste_a == coste_b
				*, coste_a, solucion_a = @t.generar_solucion_aleatoria
				*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
				if coste_b < coste_a
					mejor_solucion = solucion_b
				else
					mejor_solucion = solucion_a
				end
			end
			
			lista = Array.new
			costes = Hash.new
			
			lista << solucion_a << solucion_b
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			seleccionado = @t.torneo(lista, costes, 1)
			
			seleccionado[0].must_equal mejor_solucion			
		end
		
		it "Los parametros son un Array, una tabla de Hash y un entero positivo" do
			proc {@t.torneo(@costes, @costes, 3)}.must_raise TypeError
			proc {@t.torneo(@lista, @lista, 2)}.must_raise TypeError
			proc {@t.torneo(@lista, @costes, 1.25)}.must_raise TypeError
		end
		
		it "No se puede pasar una lista de soluciones vacia" do
			proc {@t.torneo(Array.new, @costes, 2)}.must_raise TypeError
		end
		
		it "No se puede pasar una tabla de costes vacia" do
			proc {@t.torneo(@costes, Hash.new, 3)}.must_raise TypeError
		end
		
		it "El número de costes de la tabla de Hash debe de coincidir con las soluciones pasadas" do
			*, coste_a, solucion_a = @t.generar_solucion_aleatoria
			*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
			lista = Array.new
			lista << solucion_a << solucion_b
			
			costes = Hash.new
			costes[solucion_a] = coste_a
			
			30.times do
				*, solucion = @t.generar_solucion_aleatoria
				lista << solucion
			end
			
			proc {@t.torneo(lista, costes, 1)}.must_raise TypeError
		end
	end
	
	describe "Cuando se realiza un torneo injusto" do
		before do
			@lista = Array.new
			@costes = Hash.new
			
			50.times do
				*, coste, solucion = @t.generar_solucion_aleatoria
				
				@lista << solucion
				@costes[solucion] = coste
			end
		end
		
		it "Pueden aparecer soluciones repetidas" do
			seleccionados = @t.torneo_injusto(@lista, @costes, 125)
			
			seleccionados.uniq!
			
			seleccionados.length.must_be :<, 125
		end
		
		it "Siempre se escoge a la solución de menor fitness" do
			coste_a = nil
			coste_b = nil
			
			while coste_a == coste_b
				*, coste_a, solucion_a = @t.generar_solucion_aleatoria
				*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
				if coste_b < coste_a
					mejor_solucion = solucion_b
				else
					mejor_solucion = solucion_a
				end
			end
			
			lista = Array.new
			costes = Hash.new
			
			lista << solucion_a << solucion_b
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			seleccionado = @t.torneo(lista, costes, 1)
			
			seleccionado[0].must_equal mejor_solucion
		end
		
		it "Los argumentos del metodo PHUB#torneo_injusto son un array, una tabla de hash y un número entero" do
			proc {@t.torneo_injusto(3, Hash.new, 2)}.must_raise TypeError
			proc {@t.torneo_injusto(Array.new, Array.new, 3)}.must_raise TypeError
			proc {@t.torneo_injusto(Array.new, Hash.new, 1.2)}.must_raise TypeError
		end
		
		it "La longitud de la lista de miembros seleccionados tiene el tamaño solicitado" do
			seleccionados = @t.torneo_injusto(@lista, @costes, 600)
			
			seleccionados.length.must_equal 600
		end
		
		it "No se puede pasar una lista de soluciones vacia" do
			proc {@t.torneo_injusto(Array.new, @costes, 2)}.must_raise TypeError
		end
		
		it "No se puede pasar una tabla de costes vacia" do
			proc {@t.torneo_injusto(@costes, Hash.new, 3)}.must_raise TypeError
		end
		
		it "El número de costes de la tabla de Hash debe de coincidir con las soluciones pasadas" do
			*, coste_a, solucion_a = @t.generar_solucion_aleatoria
			*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
			lista = Array.new
			lista << solucion_a << solucion_b
			
			costes = Hash.new
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			30.times do
				*, solucion = @t.generar_solucion_aleatoria
				lista << solucion
			end
			
			proc {@t.torneo_injusto(lista, costes, 1)}.must_raise TypeError
		end
	end
end
