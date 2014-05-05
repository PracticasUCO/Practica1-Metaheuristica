#! /usr/bin/env ruby

require 'getopt/long'
require_relative '../lib/PHUB/PHUB/PHUB'

# Carga los ficheros del directorio y los devuelve en un Array
def cargar_ficheros(directorio)
	ficheros = `find #{directorio}`.chomp.split(/\n/)
	ficheros.delete_if {|file| File.ftype(file) != "file"}
	return ficheros
end

def cargar_mejores_valores(fichero)
	mejores = Hash.new
	
	File.open(fichero, "r") do |file|
		file.each do |linea|
			nombre, mejor_valor = linea.chomp().split(/ /)
			mejor_valor = mejor_valor.to_f
			
			mejores[nombre] = mejor_valor
		end
	end
	
	return mejores
end

begin
	opt = Getopt::Long.getopts(
	["--help", "-h", Getopt::BOOLEAN],
	["--dir", "-d", Getopt::REQUIRED],
	["--save", "-s", Getopt::REQUIRED],
	["--show", nil, Getopt::BOOLEAN],
	["--hide-seed", nil, Getopt::BOOLEAN],
	["--best-values", nil, Getopt::REQUIRED])
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
	puts "\t --best-values: Carga el fichero con los mejores valores conocidos\n\n"
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
	
	start_e_time = Time.new
	pretty_e, coste_e, solucion_e = phub.algoritmo_evolutivo_estacionario()
	end_e_time = Time.new
	
	segundos_e = (end_e_time - start_e_time).to_i
	minutos_e = (segundos_e  /  60).to_i
	segundos_e = segundos_e  %  60
	
	puts "\n\t Estacionario: #{coste_e}. Tiempo: #{minutos_e} m #{segundos_e} s"
	
	start_g_time = Time.new
	pretty_g, coste_g, solucion_g = phub.algoritmo_evolutivo_generacional()
	end_g_time = Time.new
	
	segundos_g = (end_g_time - start_g_time).to_i
	minutos_g = (segundos_g  /  60).to_i
	segundos_g = segundos_g  %  60
	
	puts "\t Generacional: #{coste_g}. Tiempo: #{minutos_g} m #{segundos_g} s"
	
	tiempo_e = end_e_time - start_e_time
	tiempo_g = end_g_time - start_g_time
	
	total_s = segundos_e + segundos_g
	total_m = minutos_e + minutos_g
	total_h = 0
	
	total_m += (total_s / 60).to_i
	total_s = total_s  %  60
	total_h += (total_m / 60).to_i
	total_m = total_m %  60
	
	puts "\t Tiempo consumido: #{total_h} h #{total_m} m #{total_s} s"
	puts ""
	costes[file] = [coste_e, coste_g]
	prettys[file] = [pretty_e, pretty_g]
	tiempos[file] = [tiempo_e, tiempo_g]
end

if opt["show"]
	suma = 0
	
	puts "Semilla utilizada: #{opt["seed"]}"
	puts ""
	puts "Lista de costes"
	puts "=============================================="
	
	ficheros.each do |file|
		basename = File.basename file
		
		coste = costes[file]
		tiempo = tiempos[file]
		
		coste_e = coste[0]
		coste_g = coste[1]
		
		tiempo_e = tiempo[0]
		tiempo_g = tiempo[1]
		
		segundos_e = tiempo[0].to_i
		minutos_e = (segundos_e.to_i  /  60).to_i
		segundos_e = segundos_e  %  60
		horas_e = (minutos_e  /  60).to_i
		minutos_e = minutos_e  %  60
		
		segundos_g = tiempo[1].to_i
		minutos_g = (segundos_g.to_i  /  60).to_i
		segundos_g = segundos_g  %  60
		horas_g = (minutos_g  /  60).to_i
		minutos_g = minutos_g  %  60
		
		suma += tiempo_e
		suma += tiempo_g
		
		puts "#{basename}"
		puts "Estacionario: #{coste_e} en #{horas_e} h #{minutos_e} m #{segundos_e} s"
		puts "Generacional: #{coste_g} en #{horas_g} h #{minutos_g} m #{segundos_g} s"
		puts ""
	end
	
	total_segundos = suma.to_i
	total_minutos = (total_segundos / 60).to_i
	total_segundos = total_segundos  %  60
	total_horas = (total_minutos / 60).to_i
	total_minutos = total_minutos  %  60
	
	puts "=============================================="
	puts "Tiempo total: #{total_horas} h #{total_minutos} m #{total_segundos} s"
	puts ""
end

if opt["best-values"]
	mejores = cargar_mejores_valores(opt["best-values"])
else
	mejores = Hash.new
end

if opt["save"]
	File.open(opt["save"], File::CREAT|File::APPEND|File::RDWR) do |save|
		save.puts "Semilla; #{opt["seed"]}"
		save.puts ""
		save.puts "Instancia;Tipo;Coste AGg;Tiempo AGg;Coste AGe;Tiempo AGe;Mejor valor"
		
		ficheros.each do |file|
			basename = File.basename file
			tipo = "CPH"
			coste = costes[file]
			tiempo = tiempos[file]
		
			coste_e = coste[0]
			coste_g = coste[1]
		
			tiempo_e = tiempo[0]
			tiempo_g = tiempo[1]
			
			save.puts "#{basename};#{tipo};#{coste_g};#{tiempo_g};#{coste_e};#{tiempo_e};#{mejores[basename]}"
		end
	end
	
	puts "Ficheros guardados con exito en #{opt["save"]}"
end
