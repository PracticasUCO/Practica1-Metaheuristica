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

# Carga los ficheros del directorio y los devuelve en un Array
def cargar_ficheros(directorio)
	ficheros = `find #{directorio}`.chomp.split(/\n/)
	ficheros.delete_if {|file| File.ftype(file) != "file"}
	return ficheros
end

begin
	opt = Getopt::Long.getopts(
	["--help", "-h", Getopt::BOOLEAN],
	["--dir", "-d", Getopt::REQUIRED],
	["--save", "-s", Getopt::REQUIRED],
	["--show", nil, Getopt::BOOLEAN],
	["--hide-seed", nil, Getopt::BOOLEAN])
rescue Getopt::Long::Error => e
	puts "Uno o varios de los parametros opcionales es incorrecto."
	puts "Compruebe con --help la entrada antes de continuar"
end

opt["seed"] = srand(123)
srand(opt["seed"])

if opt["help"]
	puts "Este programa busca una solución al problema del PHUB mediante el uso"
	puts "de algoritmos evolutivos."
	puts "Concretamente la busqueda se realiza mediante el algoritmo evolutivo"
	puts "estacionario y el algoritmo evolutivo generacional."
	puts ""
	puts "Ejecute este programa como ./practica3.rb [OPCIONES]"
	puts "Las opciones de este programa son:"
	puts "\t --help -h: Muestra esta ayuda.\n\n"
	puts "\t --dir -d: Indica la carpeta donde se encuentran todos los ficheros"
	puts "\t de instancias del PHUB\n\n"
	puts "\t --save -s: Indica el lugar donde guardar el coste de la solución de"
	puts "\t cada fichero procesado.\n\n"
	puts "\t --show: Cuando se especifica se muestra por pantalla la solución"
	puts "\t generada y su coste.\n\n"
	puts "\t --hide-seed: No muestra la semilla generada. Valor por defecto: false\n\n"
	exit(0)
end

unless opt["dir"]
	puts "Es obligatorio especificar la ruta donde se encuentran los ficheros"
	puts "a procesar. Use la opción --dir para ello."
	puts "Si necesita más ayuda use la opción  --help"
	exit(0)
end

unless File.ftype(opt["dir"]) == "directory"
	tipo = File.ftype(opt["dir"])
	puts "Opcion erronea: --dir #{opt["dir"]} --> #{tipo}"
	puts "Debe de especificar un directorio."
	exit(0)
end

unless opt["show"]
	opt["show"] = false
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

ficheros = cargar_ficheros(opt["dir"])
