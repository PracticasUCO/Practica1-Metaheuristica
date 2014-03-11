#! /usr/bin/env ruby -w
 
require 'getopt/long'

opt = Getopt::Long.getopts(
	["--help", "-h", Getopt::BOOLEAN],
	["--type", "-p", Getopt::REQUIRED],
	["--instance", "-f", Getopt::REQUIRED],
	["--seed", "-s", Getopt::REQUIRED]
	)

if opt["help"]
	puts "La forma de uso de este script es:"
	puts "# ruby nombreScript [opciones]"
	puts ""
	puts "Las opciones de este programa son:"
	puts "\t--help o -h: Muestra esta ayuda"
	puts
	puts "\t--type o -p: Indica el tipo de problema a tratar, es un"
	puts "parametro que debe de introduccirse siempre. Puede contener"
	puts "los siguientes valores:"
	puts "\t\t-MMDP: Resolución de Max Min Diversity Problem"
	puts "\t\t-CWP: Resolución de problema CutWidth Problem"
	puts "\t\t-TSP: Resolución de Travelling Salesman Problem"
	puts "\t\t-CPH: Resolución de Capacited P-Hub Problem"
	puts
	puts "\t--instance o -f: Indica de donde leer la instancia. Debe de introduccirse"
	puts "siempre este parametro"
	puts
	puts "\t--seed o -s: Indica la semilla del programa"
	exit
end

if opt["seed"]
	opt["seed"] = opt["seed"].to_i
	srand opt["seed"]
	puts "Semilla establecida a: #{opt["seed"]}"
end