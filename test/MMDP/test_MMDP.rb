#! /usr/bin/env ruby

require_relative '../../lib/MMDP/MMDP/MMDP'
require_relative '../../lib/MMDP/BasicMMDP/BasicMMDP'
require 'minitest/autorun'

describe MMDP do
	before do
		@t = MMDP::MMDP.new("instancias/P2/MMDP/GKD-Ia_71_n30_m24.txt")
		@b = MMDP::BasicMMDP.new("instancias/P2/MMDP/GKD-Ia_71_n30_m24.txt")
	end

	describe "Cuando se crea la clase con la instancia GKD-Ia_71_n30_m24" do
		it "Debe de tener 24 nodos solucion" do
			@t.solution_nodes.must_equal 24
		end

		it "Debe de haber leido un total de 15 nodos" do
			@t.total_nodes.must_equal 30
		end
	end

	describe "Cuando se halla una solucion mediante busqueda local." do
		it "Debe de tener una longitud de 24" do
			solucion, * = @t.generar_solucion_busqueda_local :best_improvement
			solucion.length.must_equal 24
		end

		it "El coste medio debe de ser mayor o igual que la obtenida con BasicMMDP" do

			repeticiones = 3
			suma_best_improvement = 0
			suma_aleatorio = 0

			repeticiones.times do
				*, coste_best_improvement = @t.generar_solucion_busqueda_local :best_improvement
				*, coste_aleatorio = @b.generar_solucion_aleatoria :best_improvement

				suma_best_improvement += coste_best_improvement
				suma_aleatorio += coste_aleatorio
			end

			suma_best_improvement.must_be :>=, suma_aleatorio
		end

	end

	describe "En las soluciones de busqueda local por Best Improvement" do
		it "Ninguna solucion puede superar el coste de 200 ya que estamos tratando de diversidad minima" do
			repeticiones = 3
			repeticiones.times do
				*, coste = @t.generar_solucion_busqueda_local :best_improvement

				coste.must_be :<, 200
			end
		end

		it "El coste de la solucion debe de ser mayor que cero" do
			*, coste = @t.generar_solucion_busqueda_local :best_improvement

			coste.must_be :>, 0
		end
	end

	describe "En las soluciones de busqueda local por first Improvement" do
		it "La soluciones deben de tener una longitud de 24" do
			solucion, * = @t.generar_solucion_busqueda_local :first_improvement

			solucion.length.must_equal 24
		end

		it "El coste de la solucion debe de estar entre el coste de la funcion aleatoria y el coste por best improvement" do
			5.times do
				*, coste_fi = @t.generar_solucion_busqueda_local :first_improvement
				*, coste_bi = @t.generar_solucion_busqueda_local :best_improvement
				*, coste_al = @t.generar_solucion_aleatoria

				coste_fi.must_be :>, coste_al
				coste_fi.must_be :<, coste_bi
			end
		end

		it "Las soluciones no pueden superar el coste de 200 tratando la diversidad minima" do
		end
	end
end