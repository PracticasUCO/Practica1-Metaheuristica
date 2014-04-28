#! /usr/bin/env ruby
# enconding: utf-8

require_relative '../BasicPHub/BasicPHub'
require_relative '../CapacitedPHubNode/CapacitedPHubNode'
require_relative 'c_phub'

module PHUB
	# La clase PHUB esta encargada de encontrar una buena solución para el problema
	# de CapacitedPHub.
	class PHUB < BasicPHub
		# Constructor de la clase PHUB. Recibe un string con la dirección de la base
		# de datos a leer
		def initialize(path)
			super
			@initial_population = 50
			@probability_crossing = 0.9
			@probability_mutation = 0.15
			@number_evaluations = @nodos.length * 100
		end
		
		# Ordena los elementos de una lista de soluciones según su fitness
		def sort_by_fitness!(lista_soluciones, fitness_soluciones)
			raise TypeError, "lista_soluciones debe de ser un Array" unless lista_soluciones.kind_of? Array
			raise TypeError, "fitness_soluciones debe de ser una tabla de hash" unless fitness_soluciones? Hash
			
			lista_soluciones.sort_by! {|solucion| fitness_soluciones[solucion]}
		end
		
		# Ordena los elementos de una lista de soluciones según su fitness
		def sort_by_fitness(lista_soluciones, fitness_soluciones)
			raise TypeError, "lista_soluciones debe de ser un Array" unless lista_soluciones.kind_of? Array
			raise TypeError, "fitness_soluciones debe de ser una tabla de hash" unless fitness_soluciones? Hash
			
			return lista_soluciones.sort_by {|solucion| fitness_soluciones[solucion]}
		end
		
		def reiniciar_poblacion(poblacion_actual, mejor_individuo, mejor_solucion)
			nueva_poblacion = Array.new
			lista_costes = Hash.new
			
			nueva_poblacion << mejor_individuo
			lista_costes[mejor_individuo] = mejor_solucion
			
			(@initial_population - 1).times do
				*, coste, solucion = generar_solucion_aleatoria()
				nueva_poblacion << solucion
				lista_costes[solucion] = coste
			end
			
			return nueva_poblacion, lista_costes
		end
		
		def algoritmo_evolutivo_estacionario()
			poblacion_actual = Array.new
			costes_poblacion = Hash.new
			evaluaciones = 0
			mejor_individuo = nil
			mejor_coste = nil
			
			evaluaciones_sin_mejora = 0
			
			# Se rellena la población inicial
			
			@initial_population.times do
				*, coste, solucion = generar_solucion_aleatoria()
				
				costes_poblacion[solucion] = coste
				poblacion_actual << solucion
			end
			
			# Seleccion del mejor individuo
			
			mejor_coste = costes_poblacion.values.sort![0]
			mejor_individuo = costes_poblacion.invert[mejor_coste]
			coste_inicial = mejor_coste
			
			# Inicio del algoritmo
			
			while evaluaciones < @number_evaluations
				individuoA, individuoB = ruleta(poblacion_actual, costes_poblacion, 2)
				
				puts "Mejor --> #{mejor_coste} Evaluaciones: #{(evaluaciones * 100 / @number_evaluations).to_f} %"
				
				# Si la probabilidad de cruce lo permite, cruzamos dos individuos al azar
				if rand <= @probability_crossing
					evaluaciones += 1
					
					hijoA, hijoB = cruce(individuoA, individuoB)
					mutacionA = nil
					mutacionB = nil
					conjunto = Array.new
					
					poblacion_actual << hijoA
					poblacion_actual << hijoB
					
					# Si la probabilidad de mutacion lo permite, mutamos a un individuo
					
					if rand <= @probability_mutation
						evaluaciones += 1
						mutacionA = mutar(hijoA)
						conjunto << mutacionA
						poblacion_actual << mutacionA
						
						if rand <= @probability_mutation
							evaluaciones += 1
							mutacionA2 = mutar(mutacionA)
							conjunto << mutacionA2
							poblacion_actual << mutacionA2
						end
					end
					
					# Si la probabilidad de mutacion lo permite, mutamos a un individuo
					
					if rand <= @probability_mutation
						evaluaciones += 1
						mutacionB = mutar(hijoB)
						conjunto << mutacionB
						poblacion_actual << mutacionB
						
						if rand <= @probability_mutation
							evaluaciones += 1
							mutacionB2 = mutar(mutacionB)
							conjunto << mutacionB2
							poblacion_actual << mutacionB2
						end
					end
					
					conjunto << hijoA << hijoB
					
					# Se evaluan todos los nuevos individuos
					# y se mezclan con los ya existentes
					
					costes_nuevos = evaluar_conjunto_soluciones conjunto
					costes_poblacion.merge!(costes_nuevos)
					
					# Se evalua si existe un nuevo mejor miembro
					# dentro de los nuevos individuos
					
					mejora = false
					
					conjunto.each do |nuevo_miembro|
						if costes_poblacion[nuevo_miembro] < mejor_coste
							mejor_coste = costes_poblacion[nuevo_miembro]
							mejor_individuo = nuevo_miembro
							mejora = true
						end
					end
					
					if mejora == true
						evaluaciones_sin_mejora = 0
					else
						evaluaciones_sin_mejora += 1
					end
					
					if evaluaciones_sin_mejora == 500
						evaluaciones_sin_mejora = 0
						poblacion_actual, costes_poblacion = reiniciar_poblacion(poblacion_actual, mejor_individuo, mejor_coste)
						puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
						puts "==============================================="
						puts "poblacion reiniciada"
						puts "==============================================="
						puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
					end
					
				end
				
				# Se seleccionan T - 1 individuos para la poblacion siguiente
				# El mejor individuo pasa automaticamente a la siguiente poblacion
				# sin pasar por el proceso de seleccion mediante torneo
				
				seleccion_proxima_generacion = torneo(poblacion_actual, costes_poblacion, @initial_population - 1)
				seleccion_proxima_generacion << mejor_individuo
				
				# Se borran los costes existentes de individuos que ya no estaran en la poblacion
				# Ojo: este procedimiento puede ser muy costoso, sobretodo teniendo en cuenta
				# que la seleccion por torneo podría dar tambien el coste de los individuos
				# seleccionados en lugar de solo dichos individuos.
				#
				# En un futuro habra que cambiar esto para que no se pierda mucha ejecucion
				# en esta linea.
				
				costes_poblacion.delete_if {|key, value| not seleccion_proxima_generacion.include? key}
				
				# Se hace el cambio, la generacion siguiente reemplaza a la generacion
				# actual y así el ciclo de la vida continua.
				#
				# Los costes no hace falta actualizarlos ya que se actualizaron en el paso
				# anterior
				poblacion_actual = seleccion_proxima_generacion
			end
			
			# Se genera la vision bonita de la solucion
			pretty = pretty_solution(mejor_individuo)
			
			puts "Evolucion del coste: #{coste_inicial} --> #{mejor_coste}"
			
			#Se devuelve el resultado
			return pretty, mejor_coste, mejor_individuo
		end
		
		private :sort_by_fitness
	end
end
