#! /usr/bin/env ruby

require_relative '../../lib/PHUB/PHUB/PHUB'
require_relative '../../lib/PHUB/CapacitedPHubNode/CapacitedPHubNode'
require 'minitest/autorun'

# Esta clase servirá para probar los métodos privados
# de la clase PHUB
class PHUBPrivate < PHUB::PHUB
	public :random_number, :separar_nodos, :torneo, :torneo_injusto, :ruleta, :seleccion, :get_connections
	public :get_types, :desconectar_solucion, :set_historical_connections, :merge, :set_random_connections
	public :mezclar_concentradores, :evaluar_conjunto_soluciones, :funcion_objetivo, :get_nodes, :add_clients
	public :cruce
end

describe PHUBPrivate do
	before do
		@t = PHUBPrivate.new("instancias/P3/CPH/phub_100_10_1.txt")
		@lista = Array.new
		@costes = Hash.new
		
		*, @coste_a, @elemento_a = @t.generar_solucion_aleatoria
		*, @coste_b, @elemento_b = @t.generar_solucion_aleatoria
		*, @coste_c, @elemento_c = @t.generar_solucion_aleatoria
		*, @coste_d, @elemento_d = @t.generar_solucion_aleatoria
		
		@t.desconectar_solucion(@elemento_d)
		
		50.times do
			*, coste, solucion = @t.generar_solucion_aleatoria
			
			@lista << solucion
			@costes[solucion] = coste
		end
	end
	
	describe "Cuando se llama a random_number" do
		it "Debe de devover un número entre 0-1" do
			300.times do
				numero_generado = @t.random_number
				
				numero_generado.must_be :<=, 1
				numero_generado.must_be :>=, 0
			end
		end
	end
	
	describe "Cuando se llama a PHUB#separar_nodos" do
		it "Debe de devolver dos vectores" do
			*, solucion = @t.generar_solucion_aleatoria
			
			a, b = @t.separar_nodos(solucion)
			
			a.must_be_kind_of Array
			b.must_be_kind_of Array
		end
		
		it "El primer vector debe de ser solo de concentradores" do
			*, solucion = @t.generar_solucion_aleatoria
		
			a, * = @t.separar_nodos(solucion)
			
			a.each do |nodo|
				nodo.tipo.must_equal :concentrador
			end
		end
		
		it "El segundo vector debe de ser solo de clientes" do
			*, solucion = @t.generar_solucion_aleatoria
		
			*, b = @t.separar_nodos(solucion)
			
			b.each do |nodo|
				nodo.tipo.must_equal :cliente
			end
		end
		
		it "El primer vector debe de tener una longitud igual al número de concentradores necesarios" do
			*, solucion = @t.generar_solucion_aleatoria
		
			a, * = @t.separar_nodos(solucion)
			
			a.length.must_equal @t.numero_concentradores
		end
		
		it "Recibe un Array" do
			proc {@t.separar_nodos(125)}.must_raise TypeError
		end
		
		it "El Array de entrada no puede estar vacio" do
			proc {@t.separar_nodos(Array.new)}.must_raise TypeError
		end
	end
	
	describe "Cuando se realiza un torneo" do
		it "Si se seleccionan menos soluciones que el número de aspirantes no puede haber soluciones repetidas" do
			30.times do
				ganadores = rand(48) + 2
				
				seleccionados = @t.torneo(@lista, @costes, ganadores)
				
				seleccionados.uniq!
				
				seleccionados.length.must_equal ganadores
			end
		end
		
		it "Si se intentan seleccionar el mismo número de aspirantes que soluciones se devuelve una copia de las soluciones" do
			seleccionados = @t.torneo(@lista, @costes, 50)
			seleccionados.must_equal @lista
		end
		
		it "Si se seleccionan más aspirantes que concursantes habra soluciones repetidas" do
			seleccionados = @t.torneo(@lista, @costes, 125)
			
			seleccionados.length.must_equal 125
		end
		
		it "Siempre gana aquella solución con mejor fitness" do
			coste_a = nil
			coste_b = nil
			
			while coste_a == coste_b
				*, coste_a, solucion_a = @t.generar_solucion_aleatoria
				*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
				if coste_b < coste_a
					mejor_solucion = solucion_b
				else
					mejor_solucion = solucion_a
				end
			end
			
			lista = Array.new
			costes = Hash.new
			
			lista << solucion_a << solucion_b
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			seleccionado = @t.torneo(lista, costes, 1)
			
			seleccionado[0].must_equal mejor_solucion			
		end
		
		it "Los parametros son un Array, una tabla de Hash y un entero positivo" do
			proc {@t.torneo(@costes, @costes, 3)}.must_raise TypeError
			proc {@t.torneo(@lista, @lista, 2)}.must_raise TypeError
			proc {@t.torneo(@lista, @costes, 1.25)}.must_raise TypeError
		end
		
		it "No se puede pasar una lista de soluciones vacia" do
			proc {@t.torneo(Array.new, @costes, 2)}.must_raise TypeError
		end
		
		it "No se puede pasar una tabla de costes vacia" do
			proc {@t.torneo(@costes, Hash.new, 3)}.must_raise TypeError
		end
		
		it "El número de costes de la tabla de Hash debe de coincidir con las soluciones pasadas" do
			*, coste_a, solucion_a = @t.generar_solucion_aleatoria
			*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
			lista = Array.new
			lista << solucion_a << solucion_b
			
			costes = Hash.new
			costes[solucion_a] = coste_a
			
			30.times do
				*, solucion = @t.generar_solucion_aleatoria
				lista << solucion
			end
			
			proc {@t.torneo(lista, costes, 1)}.must_raise TypeError
		end
	end
	
	describe "Cuando se realiza un torneo injusto" do
		it "Pueden aparecer soluciones repetidas" do
			seleccionados = @t.torneo_injusto(@lista, @costes, 125)
			
			seleccionados.uniq!
			
			seleccionados.length.must_be :<, 125
		end
		
		it "Siempre se escoge a la solución de menor fitness" do
			coste_a = nil
			coste_b = nil
			
			while coste_a == coste_b
				*, coste_a, solucion_a = @t.generar_solucion_aleatoria
				*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
				if coste_b < coste_a
					mejor_solucion = solucion_b
				else
					mejor_solucion = solucion_a
				end
			end
			
			lista = Array.new
			costes = Hash.new
			
			lista << solucion_a << solucion_b
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			seleccionado = @t.torneo(lista, costes, 1)
			
			seleccionado[0].must_equal mejor_solucion
		end
		
		it "Los argumentos del metodo PHUB#torneo_injusto son un array, una tabla de hash y un número entero" do
			proc {@t.torneo_injusto(3, Hash.new, 2)}.must_raise TypeError
			proc {@t.torneo_injusto(Array.new, Array.new, 3)}.must_raise TypeError
			proc {@t.torneo_injusto(Array.new, Hash.new, 1.2)}.must_raise TypeError
		end
		
		it "La longitud de la lista de miembros seleccionados tiene el tamaño solicitado" do
			seleccionados = @t.torneo_injusto(@lista, @costes, 600)
			
			seleccionados.length.must_equal 600
		end
		
		it "No se puede pasar una lista de soluciones vacia" do
			proc {@t.torneo_injusto(Array.new, @costes, 2)}.must_raise TypeError
		end
		
		it "No se puede pasar una tabla de costes vacia" do
			proc {@t.torneo_injusto(@costes, Hash.new, 3)}.must_raise TypeError
		end
		
		it "El número de costes de la tabla de Hash debe de coincidir con las soluciones pasadas" do
			*, coste_a, solucion_a = @t.generar_solucion_aleatoria
			*, coste_b, solucion_b = @t.generar_solucion_aleatoria
			
			lista = Array.new
			lista << solucion_a << solucion_b
			
			costes = Hash.new
			costes[solucion_a] = coste_a
			costes[solucion_b] = coste_b
			
			30.times do
				*, solucion = @t.generar_solucion_aleatoria
				lista << solucion
			end
			
			proc {@t.torneo_injusto(lista, costes, 1)}.must_raise TypeError
		end
	end
	
	describe "Cuando se hace una selección por medio de la ruleta" do
		it "Pueden aparecer soluciones repetidas" do
			seleccionados = @t.ruleta(@lista, @costes, 150)
			
			seleccionados.uniq!
			
			seleccionados.length.must_be :<, 150
		end
		
		it "Los parametros de entrada son un array, una tabla de hash y un número entero" do
			proc {@t.ruleta(@costes, @costes, 3)}.must_raise TypeError
			proc {@t.ruleta(@lista, @lista, 3)}.must_raise TypeError
			proc {@t.ruleta(@lista, @costes, 1.3)}.must_raise TypeError
		end
		
		it "No puede recibir una lista de soluciones vacía" do
			proc {@t.ruleta(Array.new, @costes, 3)}.must_raise TypeError
		end
		
		it "El número de elementos de la tabla de hash debe coincidir con el número de soluciones" do
			lista = Array.new
			costes = Hash.new
			
			10.times do
				*, coste, solucion = @t.generar_solucion_aleatoria
				lista << solucion
				costes[solucion] = coste
			end
			
			10.times do
				*, solucion = @t.generar_solucion_aleatoria
				lista << solucion
			end
			
			proc {@t.ruleta(lista, costes, 5)}.must_raise TypeError
		end
		
		it "Aquellas soluciones con mejor fitness se seleccionan con más frecuencia" do

			*, solucion = @t.generar_solucion_aleatoria
			
			best_fitness = 5
			best_solution = solucion
			
			lista = Array.new
			costes = Hash.new
			
			repeticiones = Hash.new(0)
			
			lista << best_solution
			costes[best_solution] = best_fitness
			
			24.times.with_index do |index|
				*, solucion = @t.generar_solucion_aleatoria
				costes[solucion] = (15*index) + 15
				lista << solucion
				
			end
			
			seleccionados = @t.ruleta(lista, costes, 10000)
			
			seleccionados.each do |s|
				repeticiones[s] += 1
			end

			repeticiones.keys.each do |key|
				next if key == best_solution
				next if repeticiones[key] == best_solution
				
				repeticiones[key].must_be :<, repeticiones[best_solution]
			end

		end
	end
	
	describe "El método PHUB#get_connections" do
		it "Devolver una tabla de hash" do
			tabla = @t.get_connections(@elemento_a)
			
			tabla.must_be_kind_of Hash
		end
		
		it "Recibe como parametro un array" do
			proc {@t.get_connections(@elemento_a)}.must_be_silent
			proc {@t.get_connections(Hash.new)}.must_raise TypeError	
		end
		
		it "No permite como entrada arrays vacíos" do
			proc {@t.get_connections(Array.new)}.must_raise TypeError
		end
		
		it "La tabla de hash devuelve las conexiones de dichos nodos" do
			tabla = @t.get_connections(@elemento_a)
			
			@elemento_a.each do |nodo|
				tabla[nodo].must_equal nodo.conectado_a()
			end
			
		end
	end
	
	describe "El método PHUB#get_types" do
		it "Recibe un Array como argumento" do
			proc {@t.get_types(@elemento_a)}.must_be_silent
			proc {@t.get_types("string comming")}.must_raise TypeError
		end
		
		it "El Array de entrada no puede estar vacío" do
			proc {@t.get_types(Array.new)}.must_raise TypeError
		end
		
		it "Devuelve una tabla de Hash" do
			tabla = @t.get_types(@elemento_a)
			tabla.must_be_kind_of Hash
		end
		
		it "La tabla de hash contiene el tipo de todos los nodos de la solución argumento" do
			tabla = @t.get_types(@elemento_a)
			cc = 0
			cl = 0
			
			@elemento_a.each do |nodo|
				if nodo.tipo == :concentrador
					if tabla[nodo] != true
						cc += 1
					end
				else
					if tabla[nodo] != false
						cl += 1
					end
				end
			end

			cc.must_equal 0, "Hay #{cc} concentradores clasificados como clientes"
			cl.must_equal 0, "Hay #{cl} clientes clasificados como concentradores"
		end
	end
	
	describe "Cuando se llama al método PHUB#desconectar_solucion" do
		it "Se le pasa como argumento un array" do
			proc {@t.desconectar_solucion(@elemento_c)}.must_be_silent
			proc {@t.desconectar_solucion(Hash.new)}.must_raise TypeError
		end
		
		it "El array no puede ser nulo" do
			proc {@t.desconectar_solucion(Array.new)}.must_raise TypeError
		end
		
		it "Todos los nodos del array quedan desconectados" do
			backup = @elemento_c.dup
			@t.desconectar_solucion(backup)
			
			backup.each do |nodo|
				nodo.conectado_a().length.must_equal 0
			end
			
		end
	end
	
	describe "Cuando se llama al método PHUB#set_historical_connections" do
		it "Recibe dos argumentos, un array y una tabla de hash" do
			proc {@t.set_historical_connections(@elemento_c, Hash.new)}.must_be_silent
			proc {@t.set_historical_connections(1, Hash.new)}.must_raise TypeError
			proc {@t.set_historical_connections(@elemento_c, "crazy string appear")}.must_raise TypeError
		end
		
		it "El array no puede ser nulo" do
			proc {@t.set_historical_connections(Array.new, Hash.new)}.must_raise TypeError
		end
	end
	
	describe "El metodo PHUB#merge" do
		it "Recibe dos arrays" do
			proc {@t.merge(Array.new, Array.new)}.must_be_silent
			proc {@t.merge("Crazy string appear", Array.new)}.must_raise TypeError
			proc {@t.merge(Array.new, "Crazy string appear")}.must_raise TypeError
		end
		
		it "Devuelve la union de los dos arrays" do
			r = @t.merge(@elemento_a, @elemento_b)
			
			@elemento_a.each do |value|
				r.include?(value).must_equal true
			end
			
			@elemento_b.each do |value|
				r.include?(value).must_equal true
			end	
		end
		
		it "Los arrays pasados como argumento no se alteran" do
			a_backup = @elemento_a.dup
			b_backup = @elemento_b.dup
			
			@t.merge(@elemento_a, @elemento_b)
			
			@elemento_a.must_equal a_backup
			@elemento_b.must_equal b_backup
		end
	end
	
	describe "El método PHUB#set_random_connections" do
		it "Recibe como argumento un array" do
			proc {@t.set_random_connections(@elemento_c)}.must_be_silent
			proc {@t.set_random_connections(Hash.new)}.must_raise TypeError
		end
		
		it "El array que recibe no puede ser nulo" do
			proc {@t.set_random_connections(Array.new)}.must_raise TypeError
		end
		
		it "No cambia el argumento" do
			backup = @elemento_d.dup
			r = @t.set_random_connections(@elemento_d)
			
			backup.must_equal @elemento_d
		end
		
		it "Se deja el menor numero de nodos sin conectar" do
			r = @t.set_random_connections(@elemento_d)
			
			r.each do |nodo|
				next if nodo.tipo == :concentrador
				
				if nodo.conectado_a().length == 0
					r.each do |concentrador|
						next if nodo.tipo != :concentrador
						
						nodo.demanda.must_be :>, concentrador.reserva, "El nodo #{nodo.id} (nodo.demanda) puede conectarse a #{concentrador.id} (concentrador.reserva)"
					end
					
				end
			end
			
		end
	end
	
	describe "En el método PHUB#mezclar_concentradores" do
		it "Recibe dos argumentos de tipo Array" do
			proc {@t.mezclar_concentradores(@elemento_a, @elemento_b)}.must_be_silent
			proc {@t.mezclar_concentradores(2, @elemento_b)}.must_raise TypeError
			proc {@t.mezclar_concentradores(@elemento_a, 2)}.must_raise TypeError
		end
		
		it "Ninguno de los array de entrada puede estar vacío" do
			proc {@t.mezclar_concentradores(Array.new, @elemento_b)}.must_raise TypeError
			proc {@t.mezclar_concentradores(@elemento_b, Array.new)}.must_raise TypeError
		end
		
		it "Todos los nodos de las soluciones devueltas son concentradores" do
			a, b = @t.mezclar_concentradores(@elemento_a, @elemento_b)
			
			a.each do |node|
				node.tipo.must_equal :concentrador
			end
			
			b.each do |node|
				node.tipo.must_equal :concentrador
			end
			
		end
		
		it "Devuelve dos soluciones, cada una con el mismo número de nodos" do
			50.times do
				hijo_a, hijo_b = @t.mezclar_concentradores(@elemento_a, @elemento_b)

				hijo_a.length.must_equal hijo_b.length
			end
		end
		
		it "La longitud de cada uno de los hijos es igual al número de concentradores inicial" do
			50.times do
				concentradores, * = @t.separar_nodos(@elemento_a)
				hijo_a, hijo_b = @t.mezclar_concentradores(@elemento_a, @elemento_b)
			
				hijo_a.length.must_equal concentradores.length
				hijo_b.length.must_equal concentradores.length 
			end
		end
	end
	
	describe "El método PHUB#evaluar_conjunto_soluciones" do
		it "Recibe un argumento de tipo Array" do
			lista = Array.new
			lista << @elemento_a << @elemento_b << @elemento_c << @elemento_d
			proc {@t.evaluar_conjunto_soluciones(lista)}.must_be_silent
			proc {@t.evaluar_conjunto_soluciones("Crazy string appear")}.must_raise TypeError
		end
		
		it "El Array de entrada no puede estar vacío" do
			proc {@t.evaluar_conjunto_soluciones(Array.new)}.must_raise TypeError
		end
		
		it "Devuelve una tabla de hash" do
			lista = Array.new
			lista << @elemento_a << @elemento_b << @elemento_c << @elemento_d
			costes = @t.evaluar_conjunto_soluciones(lista)
			
			costes.must_be_kind_of Hash
		end
		
		it "La tabla de hash que devuelve debe de contenter los costes de las soluciones" do
			*, coste_uno, elemento_uno = @t.generar_solucion_aleatoria
			*, coste_dos, elemento_dos = @t.generar_solucion_aleatoria
			*, coste_tres, elemento_tres = @t.generar_solucion_aleatoria
			*, coste_cuatro, elemento_cuatro = @t.generar_solucion_aleatoria
			
			# Detecte un error en la funcion objetivo, no es exactamente correcto la primera vez
			coste_uno = @t.funcion_objetivo(elemento_uno)
			coste_dos = @t.funcion_objetivo(elemento_dos)
			coste_tres = @t.funcion_objetivo(elemento_tres)
			coste_custro = @t.funcion_objetivo(elemento_cuatro)
			
			lista = Array.new
			lista << elemento_uno << elemento_dos << elemento_tres << elemento_cuatro
			costes = @t.evaluar_conjunto_soluciones(lista)
			
			costes[elemento_uno].must_equal coste_uno
			costes[elemento_dos].must_equal coste_dos
			costes[elemento_tres].must_equal coste_tres
			costes[elemento_cuatro].must_equal coste_cuatro
		end
	end
	
	describe "En el método PHUB#get_nodes" do
		it "Recibe un argumento de tipo Array" do
			proc {@t.get_nodes(@elemento_a)}.must_be_silent
			proc {@t.get_nodes("Crazy string appear")}.must_raise TypeError
		end
		
		it "Devuelve una tabla de hash" do
			r = @t.get_nodes(@elemento_a)
			
			r.must_be_kind_of Hash
		end
		
		it "La tabla de hash contiene todos los nodos presentes en la solucion a true" do
			r = @t.get_nodes(@elemento_a)
			
			@elemento_a.each do |node|
				r[node].must_equal true
			end
		end
		
		it "La tabla de hash tiene tantas llaves como nodos posibles" do
			r = @t.get_nodes(@elemento_a)
			r.keys.length.must_equal @elemento_a.length
			
			concentradores, clientes = @t.separar_nodos(@elemento_a)
			
			r = @t.get_nodes(concentradores)
			r.keys.length.must_equal @elemento_a.length
			
			r = @t.get_nodes(clientes)
			r.keys.length.must_equal @elemento_a.length
		end
		
		it "La tabla de hash tiene los nodos no presentes en la solución a false" do
			concentradores, clientes = @t.separar_nodos(@elemento_a)
			
			r = @t.get_nodes(concentradores)
			
			clientes.each do |node|
				r[node].must_equal false
			end
			
			r = @t.get_nodes(clientes)
			
			concentradores.each do |node|
				r[node].must_equal false
			end
			
		end
	end
	
	describe "El método PHUB#add_clients" do
		it "Recibe un argumento de tipo Array" do
			proc {@t.add_clients(@elemento_a)}.must_be_silent
			proc {@t.add_clients(3)}.must_raise TypeError
		end
		
		it "La solucion de vuelta tiene la longitud igual al número total de nodos" do
			@t.add_clients(@elemento_a)
			@elemento_a.length.must_equal @elemento_b.length
			
			concentradores, clientes = @t.separar_nodos(@elemento_a)
			@t.add_clients(concentradores)
			concentradores.length.must_equal @elemento_a.length
		end
		
		it "Todos los nodos añadidos son clientes" do
			concentradores, clientes = @t.separar_nodos(@elemento_a)
			lista_concentradores = @t.get_nodes(concentradores)
			@t.add_clients(concentradores)
			
			r = Array.new
			@t.add_clients(concentradores)
			
			r.each do |c|
				c.tipo.must_equal :cliente
			end
			
			concentradores.each do |c|
				next if lista_concentradores[c] == true
				
				c.tipo.must_equal :cliente
			end
		end
	end
	
	describe "Al cruzar dos soluciones" do
		it "El método recibe dos parametros que son dos Arrays" do
			proc {@t.cruce(@elemento_a, @elemento_b)}.must_be_silent
			proc {@t.cruce("Crazy string appear", @elemento_b)}.must_raise TypeError
			proc {@t.cruce(@elemento_a, "Crazy string appear")}.must_raise TypeError
		end
		
		it "Los arrays de entrada no puede estar vacíos" do
			proc {@t.cruce(Array.new, @elemento_b)}.must_raise TypeError
			proc {@t.cruce(@elemento_a, Array.new)}.must_raise TypeError
		end
		
		it "Genera dos soluciones hijas" do
			hijos = @t.cruce(@elemento_a, @elemento_b)
			
			hijos.length.must_equal 2
		end
		
		it "La longitud de los hijos debe de ser igual al numero de nodos totales" do
			hijo_a, hijo_b = @t.cruce(@elemento_a, @elemento_b)
			
			hijo_a.length.must_equal @t.nodos.length
			hijo_b.length.must_equal @t.nodos.length
		end
		
		it "Los hijos deben de tener el mismo número de nodos concentradores que los padres" do
			hijo_a, hijo_b = @t.cruce(@elemento_c, @elemento_d)
			
			con_a, * = @t.separar_nodos(@elemento_c)
			con_b, * = @t.separar_nodos(@elemento_d)
			concentradores_a, * = @t.separar_nodos(hijo_a)
			concentradores_b, * = @t.separar_nodos(hijo_b)
			
			concentradores_a.length.must_equal con_a.length
			concentradores_b.length.must_equal con_b.length
		end
		
		it "No existen clientes desconectados si un concentrador puede darles servicio" do
			hijo_a, hijo_b = @t.cruce(@elemento_a, @elemento_b)
			
			hijo_a.each do |nodo|
				next if nodo.tipo.eql? :concentrador
				next if nodo.conectado_a().length != 0
				
				hijo_a.each do |candidato|
					next if candidato.tipo.eql? :cliente
					
					nodo.demanda.must_be :>, candidato.reserva
				end
			end
			
			hijo_b.each do |nodo|
				next if nodo.tipo.eql? :concentrador
				next if nodo.conectado_a().length != 0
				
				hijo_b.each do |candidato|
					next if candidato.tipo.eql? :cliente
					
					nodo.demanda.must_be :>, candidato.reserva
				end
			end
		end
		
		it "Si un cliente esta conectado a un concentrador, dicho concentrador estara conectado a el" do
			hijo_a, hijo_b = @t.cruce(@elemento_a, @elemento_b)
			
			hijo_a.each do |nodo|
				next if nodo.tipo.eql? :concentrador
				next if nodo.conectado_a().length.eql? 0
				
				concentrador = nodo.conectado_a()
				concentrador = concentrador[0]
				
				concentrador.conectado_a().include?(nodo).must_equal true
			end
			
			hijo_b.each do |nodo|
				next if nodo.tipo.eql? :concentrador
				next if nodo.conectado_a().length.eql? 0
				
				concentrador = nodo.conectado_a()
				concentrador = concentrador[0]
				
				concentrador.conectado_a().include?(nodo).must_equal true
			end
		end
	end
end
