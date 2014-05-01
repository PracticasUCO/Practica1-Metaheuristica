#! /usr/bin/env ruby

require 'getopt/long'
require_relative '../lib/PHUB/PHUB/PHUB'

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
	end
end

ficheros = cargar_ficheros(opt["dir"])

costes = Hash.new
prettys = Hash.new
tiempos = Hash.new

ficheros.each do |file|
	basename = File.basename file
	
	print "Procesando el fichero #{basename}... "
	
	begin
		phub = PHUB::PHUB.new(file)
	rescue TypeError => e
		puts "No se corresponde a una instancia del PHUB."
		ficheros.delete(file)
		next
	rescue TypeError => e
		puts "No se corresponde a una instancia del PHUB."
		ficheros.delete(file)
		next
	end
	
	puts "lectura correcta, ejecutando algoritmos..."
	
	start_e_time = Time.new
	pretty_e, coste_e, solucion_e = phub.algoritmo_evolutivo_estacionario()
	end_e_time = Time.new
	
	puts "\t Estacionario: #{coste_e}"
	
	start_g_time = Time.new
	pretty_g, coste_g, solucion_g = phub.algoritmo_evolutivo_generacional()
	end_g_time = Time.new
	
	puts "\t Generacional: #{coste_g}"
	
	tiempo_e = end_e_time - start_e_time
	tiempo_g = end_g_time - start_g_time
	
	costes[file] = [coste_e, coste_g]
	prettys[file] = [pretty_e, pretty_g]
	tiempos[file] = [tiempo_e, tiempo_g]
end

if opt["show"]
	ficheros.each do |file|
		basename = File.basename file
		
		coste = costes[file]
		tiempo = tiempos[file]
		
		coste_e = coste[0]
		coste_g = coste[1]
		
		tiempo_e = tiempo[0]
		tiempo_g = tiempo[1]
		
		puts "Semilla utilizada: #{opt["seed"]}"
		puts "Lista de costes"
		puts "=============================================="
		puts "#{basename}"
		puts "Estacionario: #{coste_e} en #{tiempo_e} segundos"
		puts "Generacional: #{coste_g} en #{tiempo_g} segundos"
		puts ""
	end
end

if opt["save"]
	File.open(opt["save"], File::CREAT|File::APPEND|File::RDWR) do |save|
		save.puts "Semilla; #{opt["seed"]}"
		
		ficheros.each do |file|
			basename = File.basename file
			tipo = "CPH"
			coste = costes[file]
			tiempo = tiempos[file]
		
			coste_e = coste[0]
			coste_g = coste[1]
		
			tiempo_e = tiempo[0]
			tiempo_g = tiempo[1]
			
			save.puts "#{basename};#{tipo};#{coste_g};#{tiempo_g};#{coste_e};#{tiempo_e}"
		end
	end
	
	puts "Ficherso guardados con exito en #{opt["save"]}"
end
