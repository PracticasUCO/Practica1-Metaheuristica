#! /usr/bin/env ruby

n_parametros = ARGV.length

puts "Se le han pasado #{n_parametros} parametros"

ARGV.each do |argumento|

	capacidad_concentrador = nil
	capacidades = Array.new
	n_concentradores = nil
	n_nodos = nil

	File.open(argumento, "r") do |f|
		linea = f.gets.chomp()
		linea = linea.chomp().split(/ +/)
		
		while linea.include? ""
			linea.delete("")
		end
		
		capacidad_concentrador = linea[-1].to_f
		n_concentradores = linea[1].to_i
		n_nodos = linea[0].to_i
		
		f.each_with_index do |nodo, index|
			break if index == linea[0].to_i
			id, cx, cy, demanda = nodo.chomp.split(/ +/)
			demanda = demanda.to_f
			capacidades << demanda
		end
	end
	
	n_clientes = n_nodos - n_concentradores
	media = 0
	variacion = 0

	capacidades.each do |c|
		media += c
	end

	media /= capacidades.length

	capacidades.each do |c|
		variacion += (c - media) ** 2
	end

	variacion /= capacidades.length

	desviacion = Math.sqrt(variacion)
	
	puts "==================================================================="
	puts ""
	puts "Fichero: #{argumento}"
	puts "Numero de nodos: #{n_nodos}"
	puts "Numero de concentradores: #{n_concentradores}"
	puts "Clientes: #{n_clientes}"
	puts "Capacidad del concentrador: #{capacidad_concentrador}"
	puts "Media de la demanda: #{media}"
	puts "Desviacion de la demanda: #{desviacion}"
	puts "Oscilacion demanda: #{media - desviacion} - #{media + desviacion}"
	puts ""
	puts "Valores de la funcion objetivo:"
	puts "Sin controlar la capacidad:"
	puts "Minimo: #{n_clientes * (media - desviacion)}  Maximo: #{n_clientes * (media + desviacion)}"
	puts ""
	puts "Controlando la capacidad:"
	puts "Capacidad maxima a soportar: #{n_concentradores * capacidad_concentrador}"
	
	if n_clientes * (media - desviacion) < n_concentradores * capacidad_concentrador
		print "Minimo: #{n_clientes * (media - desviacion)}"
	else
		print "Minimo: #{n_concentradores * capacidad_concentrador}"
	end
	
	if n_clientes * (media + desviacion) < n_concentradores * capacidad_concentrador
		puts "  Maximo: #{n_clientes * (media + desviacion)}"
	else
		puts "  Maximo: #{n_concentradores * capacidad_concentrador}"
	end
	
end
