#! /usr/bin/env ruby

require_relative '../../lib/MMDP/MMDP/MMDP'
require 'minitest/autorun'

describe MMDP do
	before do
		@t = MMDP.new("instancias/P2/MMDP/GKD-Ia_41_n15_m9.txt")
	end
end