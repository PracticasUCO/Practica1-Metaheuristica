#! /usr/bin/env ruby

require_relative '../../lib/MMDP/MMDP/MMDP'
require_relative '../../lib/MMDP/BasicMMDP/BasicMMDP'
require 'minitest/autorun'

describe MMDP do
	before do
		@t = MMDP::MMDP.new("instancias/P2/MMDP/GKD-Ia_71_n30_m24.txt")
		@b = MMDP::BasicMMDP.new("instancias/P2/MMDP/GKD-Ia_71_n30_m24.txt")
		@repeticiones = 25
	end

	describe "Cuando se crea la clase con la instancia GKD-Ia_71_n30_m24" do
		it "Debe de tener 24 nodos solucion" do
			@t.solution_nodes.must_equal 24
		end

		it "Debe de haber leido un total de 15 nodos" do
			@t.total_nodes.must_equal 30
		end
	end

	describe "Cuando se halla una solucion mediante busqueda local mediante Best Improvement" do
		it "Debe de tener una longitud de 24" do
			solucion, * = @t.generar_solucion_busqueda_local :best_improvement
			solucion.length.must_equal 24
		end

		it "La solucion no puede tener valores repetidos" do
			@repeticiones.times do
				solucion, * = @t.generar_solucion_busqueda_local :best_improvement

				solucion.uniq!

				solucion.length.must_be :==, @t.solution_nodes
			end
		end

	end

	describe "En las soluciones de busqueda local por Best Improvement" do
		it "Ninguna solucion puede superar el coste de 200 ya que estamos tratando de diversidad minima" do
			@repeticiones.times do
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

		it "Las soluciones no pueden superar el coste de 200 tratando la diversidad minima" do
			@repeticiones.times do
				*, coste_first_improvement = @t.generar_solucion_busqueda_local :first_improvement

				coste_first_improvement.must_be :<=, 200
			end
		end

		it "La solucion no puede tener valores repetidos" do
			@repeticiones.times do
				solucion, * = @t.generar_solucion_busqueda_local :first_improvement

				solucion.uniq!

				solucion.length.must_be :==, @t.solution_nodes
			end
		end
	end
end