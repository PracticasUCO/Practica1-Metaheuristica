#! /usr/bin/env ruby

require_relative '../../lib/MMDP/MMDP/MMDP'
require_relative '../../lib/MMDP/BasicMMDP/BasicMMDP'
require 'minitest/autorun'

describe MMDP do
	before do
		@t = MMDP::MMDP.new("instancias/P2/MMDP/GKD-Ia_41_n15_m9.txt")
		@b = MMDP::BasicMMDP.new("instancias/P2/MMDP/GKD-Ia_41_n15_m9.txt")
	end

	describe "Cuando se crea la clase con la instancia GKD-Ia_41_n15_m9" do
		it "Debe de tener 9 nodos solucion" do
			@t.solution_nodes.must_equal 9
		end

		it "Debe de haber leido un total de 15 nodos" do
			@t.total_nodes.must_equal 15
		end

		it "Debe de tener de tratar de obtener el minimo de la funcion objetivo" do
			@t.clasificador.must_equal :minima
		end

		it "El criterio de parada por defecto es :max_iteraciones" do
			@t.condicion_parada.must_equal :auto
		end
	end

	describe "Cuando se halla una solucion mediante busqueda local." do
		it "Debe de tener una longitud de 9" do
			solucion, * = @t.generar_solucion_busqueda_local
			solucion.length.must_equal 9
		end

		it "El coste medio debe de ser mayor o igual que la obtenida con BasicMMDP" do

			repeticiones = 30
			suma_best_improvement = 0
			suma_aleatorio = 0

			repeticiones.times do
				*, coste_best_improvement = @t.generar_solucion_busqueda_local
				*, coste_aleatorio = @b.generar_solucion_aleatoria

				suma_best_improvement += coste_best_improvement
				suma_aleatorio += coste_aleatorio
			end

			suma_best_improvement.must_be :>=, suma_aleatorio
		end

	end

	describe "En las soluciones de busqueda local por Best Improvement" do
		it "Ninguna solucion puede superar el coste de 300 ya que estamos tratando de diversidad minima" do
			repeticiones = 30
			suma_costes = 0
			repeticiones.times do
				*, coste = @t.generar_solucion_busqueda_local

				suma_costes += coste
			end

			suma_costes.must_be :<, 400*repeticiones
		end

		it "El coste de la solucion debe de ser mayor que cero" do
			*, coste = @t.generar_solucion_busqueda_local

			coste.must_be :>, 0
		end
	end

	describe "Cuando se cambie el criterio de parada." do
		it "Debe de reflejarse en el interior de la clase" do
			@t.condicion_parada = :auto
			@t.condicion_parada.must_equal :auto

			@t.condicion_parada = :max_iteraciones
			@t.condicion_parada.must_equal :max_iteraciones

			@t.condicion_parada = :temperatura
			@t.condicion_parada.must_equal :temperatura
		end
	end

	describe "Cuando se introduccen mal los parametros del criterio de parada" do
		it "Debe de saltar una excepcion del tipo TypeError" do
			proc {@t.condicion_parada = 15}.must_raise TypeError
			proc {@t.condicion_parada = 1.3}.must_raise TypeError
			proc {@t.condicion_parada = "adf"}.must_raise TypeError
			proc {@t.condicion_parada = nil}.must_raise TypeError
			proc {@t.condicion_parada = :other}.must_raise TypeError
		end
	end
end