#! /usr/bin/env ruby -w
# encoding: utf-8

require_relative 'class/MMDP/BasicMMDP/BasicMMDP'
require_relative 'class/CWP/BasicCWP/BasicCWP'
require_relative 'class/PHUB/BasicPHub/BasicPHub'
require_relative 'class/TSP/BasicTSP/BasicTSP'
require 'getopt/long'

def mostrar_error_fichero_no_encontrado(fichero)
	puts "El fichero introduccido no pudo abrirse. Compruebe si es correcto"
	puts "Fichero: #{fichero}"
	exit
end

def mostrar_error_fichero_incorrecto(fichero)
	puts "El fichero no parece ser correcto. Compruebe el fichero antes de ejecutar"
	puts "el programa"
	puts "Fichero: #{fichero}"
	exit
end

begin

opt = Getopt::Long.getopts(
	["--help", "-h", Getopt::BOOLEAN],
	["--type", "-p", Getopt::REQUIRED],
	["--instance", "-f", Getopt::REQUIRED],
	["--seed", "-s", Getopt::REQUIRED],
	["--loops", "-l", Getopt::REQUIRED]
	)
rescue Getopt::Long::Error => e
	puts "Una o varias de las opciones introduccidas es incorrecta."
	puts "Comprueba la entrada antes de continuar"
	exit
end

if opt["help"]
	puts "La forma de uso de este script es:"
	puts "# ruby nombreScript [opciones]"
	puts ""
	puts "Las opciones de este programa son:"
	puts "\t --help o -h: Muestra esta ayuda"
	puts
	puts "\t --type o -p: Indica el tipo de problema a tratar, es un"
	puts "\t parametro que debe de introduccirse siempre. Puede contener"
	puts "\t los siguientes valores:"
	puts "\t \t -MMDP: Resolución de Max Min Diversity Problem"
	puts "\t \t -CWP: Resolución de problema CutWidth Problem"
	puts "\t \t -TSP: Resolución de Travelling Salesman Problem"
	puts "\t \t -CPH: Resolución de Capacited P-Hub Problem"
	puts
	puts "\t --instance o -f: Indica de donde leer la instancia. Debe de introduccirse"
	puts "\t siempre este parametro"
	puts
	puts "\t --seed o -s: Indica la semilla del programa"
	puts "\t --loops o -l: Indica el numero de repeticiones del programa."
	puts "\t si no se especifica, tiene un valor por defecto de 1000"
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
		problem = BasicMMDP.new(opt['instance'])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt['instance'])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	end
	
	puts "Instancia Max Min Diversity Problem cargada correctamente"
elsif opt["type"] == "CWP"
	begin
		problem = BasicCWP.new(opt['instance'])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt['instance'])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	end
	
	puts "Instancia CutWidth Problem cargada correctamente"
elsif opt["type"] == "TSP"
	begin
		problem = BasicTSP.new(opt['instance'])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt['instance'])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	end
	
	puts "Instancia Travelling Salesman Problem cargada correctamente"
elsif opt["type"] == "CPH"
	begin
		problem = BasicPHub.new(opt['instance'])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt['instance'])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt['instance'])
	end
	
	puts "Instancia Capacited PHub cargada correctamente"
else
	puts "Argumento no reconocido: #{opt['type']}"
	exit
end

if opt["loops"]
	opt["loops"] = opt["loops"].to_i
else
	opt["loops"] = 1000
end

puts "Numero de iteraciones establecido: #{opt["loops"]}"

minimo = Float::INFINITY
maximo = -Float::INFINITY

opt["loops"].times.with_index do |index|
	puts "Iteracion #{index + 1}"
	solucion, coste = problem.generar_solucion_aleatoria
	puts "Solucion: #{solucion}"
	puts "Coste: #{coste}"
	puts
	
	minimo = coste if coste < minimo
	maximo = coste if coste > maximo
	solucion.clear
end

puts "extremos mínimo=#{minimo} máximo=#{maximo}"