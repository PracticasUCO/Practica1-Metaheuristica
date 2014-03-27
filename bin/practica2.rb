#! /usr/bin/env ruby
# encoding: utf-8

require_relative '../lib/MMDP/BasicMMDP/BasicMMDP'
require_relative '../lib/TSP/BasicTSP/BasicTSP'
require 'getopt/long'

begin

opt = Getopt::Long.getopts(
	["--help", "-h", Getopt::BOOLEAN],
	["--type", "-p", Getopt::REQUIRED],
	["--instance", "-f", Getopt::REQUIRED],
	["--seed", "-s", Getopt::REQUIRED],
	["--loops", "-l", Getopt::REQUIRED],
	["--search", , Getopt::REQUIRED]
	)
rescue Getopt::Long::Error => e
	puts "Una o varias de las opciones introduccidas es incorrecta."
	puts "Comprueba la entrada antes de continuar"
	exit
end

if opt["help"]
	puts "La forma de uso de este script es"
	puts "\t ruby practica2.rb [opciones]"
	puts
	puts "Las opciones que se pueden utilizar son:"
	puts "\t --type o -p: Indica el tipo de problema a resolver."
	puts "\t las opciones soportadas son:"
	puts "\t \t MMDP: Resuelve el problema de hallar un conjunto de individuos maximizando su diversidad minima"
	puts "\t \t TSP: Resuelve el problema del viajante de comercio"
	puts
	puts "\t --type es un argumento de uso obligatorio."
	puts
	puts "\t --instance o -f: Indica donde se encuentra la instancia a leer"
	puts
	puts "\t --instance es un argumento de uso obligatorio."
	puts
	puts "\t --seed: Inicializa una semilla. Si se omite se tomara un valor aleatorio"
	puts
	puts "\t--loops: Indica el numero de iteraciones a dar como maximo para hallar la solucion"
	puts
	puts "\t --search: Indica el tipo de busqueda a realizar, puede tener los valores:"
	puts "\t \t first_improvement: Para una busqueda local usando el selector de primero el mejor"
	puts "\t \t best_improvement: Para una busqueda local usando el selector de selección del mejor candidato"
	puts "\t \t enfriamiento_simulado: Para una busqueda local usando el selector de enfriamiento simulado"
	puts
	puts "\t \t --search es un parametro obligatorio"
	puts "\t \t Si no se especifica se usara por defecto first_improvement"
	puts
	puts "\t --help: Muestra esta ayuda."
	exit
end

unless opt["type"] and opt["instance"] and opt["search"]
	puts "Los argumentos --type, --instance y --search son obligatorios"
	exit
end

if opt["seed"]
	srand opt["seed"].to_i
end
