#! /usr/bin/env ruby

require_relative '../../lib/MMDP/MMDP/MMDP'
require 'minitest/autorun'

describe MMDP do
	before do
		@t = MMDP::MMDP.new("instancias/P2/MMDP/GKD-Ia_41_n15_m9.txt")
	end

	describe "Cuando se crea la clase con la instancia GKD-Ia_41_n15_m9" do
		it "Debe de tener 9 nodos solucion" do
			@t.solution_nodes.must_equal 9
		end

		it "Debe de haber leido un total de 15 nodos" do
			@t.total_nodes.must_equal 15
		end
	end
end