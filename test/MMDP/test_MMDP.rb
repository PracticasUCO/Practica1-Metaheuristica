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
	end

	describe "Cuando se halla una solucion mediante busqueda local." do
		it "Debe de tener una longitud de 9" do
			solucion, * = @t.generar_solucion_busqueda_local
			solucion.length.must_equal 9
		end

		it "El coste debe de ser mayor o igual que la obtenida con BasicMMDP" do
			*, coste_best_improvement = @t.generar_solucion_busqueda_local
			*, coste_aleatorio = @b.generar_solucion_aleatoria

			coste_best_improvement.must_be :>=, coste_aleatorio
		end

		it "Ninguna solucion puede superar el coste de 300 ya que estamos tratando de diversidad minima" do
			*, coste = @t.generar_solucion_busqueda_local

			coste.must_be :<, 300
		end
	end
end