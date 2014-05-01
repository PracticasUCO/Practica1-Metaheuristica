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
	["--save", "-s", Getopt::REQUIRED])
rescue Getopt::Long::Error => e
	puts "Uno o varios de los parametros opcionales es incorrecto."
	puts "Compruebe con --help la entrada antes de continuar"
end
