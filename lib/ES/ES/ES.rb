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
		#	- tipo: Indica el tipo de función que se usara para disminuir la temperatura
  	#		Actualmente solo puede ser :geometrica
		#	- coeficiente: Indica el valor del coeficiente usado en la función de disminución
  	#		de la temperatura. El valor del coeficiente depende del tipo de enfriamiento
    #   simulado.
    #     - Para un enfriamiento de tipo geometrico debe oscila entre 0 y 1
    #       exclusive.
  		def initialize(tipo: :geometrica, coeficiente: 0.80)
  			raise TypeError, "tipo de valer :geometrica" unless tipo.eql? :geometrica
  			raise TypeError, "coeficiente debe de ser un valor numerico" unless coeficiente.kind_of? Numeric

  			if coeficiente >= 1 or coeficiente <= 0
  				raise TypeError, "coeficiente debe de ser menor o igual que 1 (ambos exclusive)"
  			end

  			@tipo = tipo
  			@coeficiente = coeficiente
  			@temperatura = 1
  		end
	end
end