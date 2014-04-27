#! /usr/bin/env ruby

def distancia(coordenadasA, coordenadasB)
	cuadrados = (coordenadasA[0] - coordenadasB[0]) ** 2
	cuadrados += (coordenadasA[1] - coordenadasB[1]) ** 2
	distancia = Math.sqrt(cuadrados)
	return distancia
end

n_parametros = ARGV.length

puts "Se le han pasado #{n_parametros} parametros"

ARGV.each do |argumento|

	capacidad_concentrador = nil
	capacidades = Array.new
	n_concentradores = nil
	n_nodos = nil
	posiciones = Array.new
	coste_distancias = Hash.new(Array.new)

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
			
			coordenadas = Array.new
			coordenadas << cx.to_f << cy.to_f
			posiciones << coordenadas
			
			demanda = demanda.to_f
			capacidades << demanda
		end
	end
	
	posiciones.each do |inicio|
		posiciones.each do |final|
			d = distancia(inicio, final)
			llaveA = Array.new
			llaveB = Array.new
			
			llaveA << inicio << final
			llaveB << final << inicio
			
			coste_distancias[llaveA] = d
			coste_distancias[llaveB] = d
		end
	end
	
	media_costes = 0
	varianza_costes = 0
	desviacion_costes = 0
	n_costes = coste_distancias.values.length
	
	coste_distancias.values.each do |c|
		media_costes += c
	end
	
	media_costes /= n_costes
	
	coste_distancias.values.each do |c|
		varianza_costes += (c - media_costes) ** 2
	end
	
	varianza_costes /= n_costes
	desviacion_costes = Math.sqrt(varianza_costes)
	
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
	
	n_clientes_max = ((n_concentradores * capacidad_concentrador) / (media - desviacion)).to_i
	n_clientes_min = ((n_concentradores * capacidad_concentrador) / (media + desviacion)).to_i
	lower_coste = media_costes - desviacion_costes
	upper_coste = media_costes + desviacion_costes
	
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
	puts "Se pueden atender a: #{n_clientes_min} - #{n_clientes_max} clientes"
	puts ""
	puts "Media de los costes: #{media_costes}"
	puts "Desviacion del coste: #{desviacion_costes}"
	puts "Oscilacion del coste: #{lower_coste} - #{upper_coste}"
	puts ""
	puts "Funcion objetivo."
	puts "Valor minimo esperado: #{lower_coste * n_clientes_min}"
	puts "Valor maximo esperado: #{upper_coste * n_clientes}"
	puts "Se espera el centro entre: #{lower_coste * n_clientes_min} - #{upper_coste * n_clientes_max}"
	
end
