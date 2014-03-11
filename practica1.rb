#! /usr/bin/env ruby -w

require_relative 'class/BasicMMDP'
require_relative 'class/BasicCWP'
require_relative 'class/BasicPHub'
require_relative 'class/BasicTSP'
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
	srand opt["seed"].to_i
	puts "Semilla establecida a: #{opt["seed"]}"
end

unless opt["type"] and opt["instance"]
	puts "Los argumenos --type and --instance son obligatorios"
	puts "Escriba --help para más información"
	exit
end

if opt["type"] == "MMDP"
	
	begin
	problem = BasicMMDP.new(opt["instance"])
	rescue Errno::ENOENT => e
		puts "El fichero introduccido no pudo abrirse. Compruebe si es correcto"
		puts "Fichero: #{opt["instance"]}"
		exit
	rescue TypeError => e
		puts "El fichero no parece ser correcto. Compruebe el fichero antes de ejecutar"
		puts "el programa"
		puts "Fichero: #{opt["instance"]}"
		exit
	rescue RuntimeError => e
		puts "El fichero no parece ser correcto. Compruebe el fichero antes de ejecutar"
		puts "el programa"
		puts "Fichero: #{opt["instance"]}"
		exit
	end
	
	puts "Instancia Max Min Diversity Problem cargada correctamente"
elsif opt["type"] == "CWP"
	
end