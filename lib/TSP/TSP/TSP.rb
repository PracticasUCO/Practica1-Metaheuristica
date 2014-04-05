#! /usr/bin/env ruby

require_relative '../BasicTSP/BasicTSP'
require_relative 'c_tsp'

module TSP
	class TSP < BasicTSP
		def initialize(path)
			raise "path must be a string" unless path.kind_of? String
			super
		end
	end
end