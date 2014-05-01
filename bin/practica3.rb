#! /usr/bin/env ruby

require 'getopt/long'
require_relative '../lib/PHUB/PHUB/PHUB'

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
	["--dir", "-d", Getopt::REQUIRED],
	["--threads", "-t", Getopt::REQUIRED],
	["--save", "-s", Getopt::REQUIRED],
	["--show", nil, Getopt::BOOLEAN],
	["--hide-seed", nil, Getopt::BOOLEAN])
rescue Getopt::Long::Error => e
	puts "Uno o varios de los parametros opcionales es incorrecto."
	puts "Compruebe con --help la entrada antes de continuar"
end

random_seed = srand(123)
srand(random_seed)

unless opt["hide-seed"]
	puts "\nSeed: #{random_seed}\n\n"
end

if opt["help"]	
	puts "Este programa busca una solución al problema del PHUB mediante el uso"
	puts "de algoritmos evolutivos."
	puts "Concretamente la busqueda se realiza mediante el algoritmo evolutivo"
	puts "estacionario y el algoritmo evolutivo generacional."
	puts ""
	puts "Ejecute este programa como ./practica3.rb [OPCIONES]"
	puts "Las opciones de este programa son:"
	puts "\t --help -h: Muestra esta ayuda."
	puts "\t --dir -d: Indica la carpeta donde se encuentran todos los ficheros"
	puts "\t de instancias del PHUB"
	puts "\t --threads -t: Indica el número de hilos que se usaran para procesar"
	puts "\t cada instancia. Se recomienda utilizar un número igual al número de"
	puts "\t nucleos del ordenador donde se este ejecutando."
	puts "\t --save -s: Indica el lugar donde guardar el coste de la solución de"
	puts "\t cada fichero procesado."
	puts "\t --show: Cuando se especifica se muestra por pantalla la solución"
	puts "\t generada y su coste."
	puts "\t --hide-seed: No muestra la semilla generada"
	exit(0)
end

if opt["save"] and File.exists? opt["save"]
	basename = File.basename opt["save"]
	puts "El fichero #{basename} ya existe"
	
	STDOUT.flush
	
	print "Desea sobreescribirlo (S/n)? "
	confirmacion = STDIN.gets.chomp
	
	if confirmacion == "S" or confirmacion == "s"
		puts "Se sobreescribira el fichero #{basename}"
		File.delete(opt["save"])
		File.open(opt["save"], File::CREAT|File::APPEND|File::RDWR) {}
	else
		puts "Reinicie el programa usando otro nombre de fichero."
	end
end
