#! /usr/bin/env

require_relative 'c_es'

=begin rdoc
El modulo ES engloba a las clases que pertenecen
al Enfriamiento Simulado
=end
module ES

	# La clase ES trata de representar los conceptos de Enfriammiento Simulado
	class ES
		# Constructor de la clase, recibe como parametros:
		#	- valor_inicio: Indica el valor de inicio de la temperatura, debe de ser
  	#		numerico y solo puede oscilar entre 0-1 (ambos inclusive)
		#	- tipo: Indica el tipo de función que se usara para disminuir la temperatura
  	#		Actualmente solo puede ser :geometrica
		#	- coeficiente: Indica el valor del coeficiente usado en la función de disminución
  	#		de la temperatura
    # - aceptacion: probabilidad de aceptacion en tanto por uno de una solucion distinta
  		def initialize(valor_inicio: 1, tipo: :geometrica, coeficiente: 0.85, aceptacion: 1)
  			raise TypeError, "valor_inicio debe de ser numerico" unless valor_inicio.kind_of? Numeric
  			raise TypeError, "tipo de valer :geometrica" unless tipo.eql? :geometrica
  			raise TypeError, "coeficiente debe de ser un valor numerico" unless coeficiente.kind_of? Numeric
        raise TypeError, "aceptacion debe de ser un valor numerico" unless aceptacion.kind_of? Numeric

  			if valor_inicio > 1 or valor_inicio < 0
  				raise TypeError, "valor_inicio debe de estar entre 0 y 1 (ambos inclusive)"
  			end

  			if coeficiente >= 1 or coeficiente <= 0
  				raise TypeError, "coeficiente debe de ser menor o igual que 1 (ambos exclusive)"
  			end

  			@valor_inicio = valor_inicio
  			@tipo = tipo
  			@coeficiente = coeficiente
  			@temperatura = valor_inicio
        @aceptacion = aceptacion
  		end
	end
end