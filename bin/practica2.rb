#! /usr/bin/env ruby
# encoding: utf-8

require_relative '../lib/MMDP/MMDP/MMDP'
require_relative '../lib/TSP/TSP/TSP'
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
	["--loops", "-l", Getopt::REQUIRED],
	["--search", "-a", Getopt::REQUIRED],
	)
rescue Getopt::Long::Error => e
	puts "Una o varias de las opciones introduccidas es incorrecta."
	puts "Comprueba la entrada antes de continuar"
	exit
end

if opt["help"]
	puts "El programa puede ser invocado con los siguientes parametros:"
	puts "\t --help -h: Muestra esta ayuda"
	puts "\t --type -p: Indica el tipo de problema a resolver. El valor que"
	puts "\t puede tomar es MMDP o TSP"
	puts "\t --instance -f: Indica que instancia ejecutar."
	puts "\t --seed -s: El numero de la semilla a ejecutar. Si se omite"
	puts "\t se usara un valor aleatorio"
	puts "\t --loops -l: Numero de iteraciones a dar por instancia"
	puts "\t --search -a: Tipo de busqueda a realizar puede tomar los"
	puts "\t siguientes valores:"
	puts "\t \t - first_improvement"
	puts "\t \t - best_improvement"
	puts "\t \t - enfriamiento_simulado"
	exit
end

unless opt["type"] and opt["instance"] and opt["search"]
	puts "Los argumentos --type, --instance y --search son obligatorios"
	exit
end

if opt["seed"]
	srand opt["seed"].to_i
end

if opt["type"] == "MMDP"
	begin
		problem = MMDP::MMDP.new(opt["instance"])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt["instance"])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt["instance"])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt["instance"])
	end
elsif opt["type"] == "TSP"
	begin
		problem = TSP::TSP.new(opt["instance"])
	rescue Errno::ENOENT => e
		mostrar_error_fichero_no_encontrado(opt["instance"])
	rescue TypeError => e
		mostrar_error_fichero_incorrecto(opt["instance"])
	rescue RuntimeError => e
		mostrar_error_fichero_incorrecto(opt["instance"])
	end
else
	puts "No se reconocio el tipo: #{opt["type"]}"
	exit
end

if opt["loops"]
	opt["loops"] = opt["loops"].to_i
else
	opt["loops"] = 100
end

opt["search"] = opt["search"].to_sym

minimo = Float::INFINITY
maximo = -Float::INFINITY

opt["loops"].times.with_index do |index|
	solucion, coste = problem.generar_solucion_busqueda_local(opt["search"])
	puts "Solucion #{index + 1}: #{solucion}"
	puts "Coste: #{coste}"
	puts

	minimo = coste if coste < minimo
	maximo = coste if coste > maximo
end

puts "Extremos generados --> Minimo: #{minimo} Maximo: #{maximo}"

if opt["type"] == "MMDP"
	puts "Función objetivo final: #{maximo}"
else
	puts "Función objetivo final: #{minimo}"
end