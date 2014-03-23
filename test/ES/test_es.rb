#! /usr/bin/env ruby

require 'minitest/autorun'
require_relative '../../lib/ES/ES/ES'

class TestES < MiniTest::Test
	def setup
		@t_basic = ES::ES.new(valor_inicio: 1, tipo: :geometrica, coeficiente: 0.99)
	end

	def test_constructor
		assert_equal(1, @t_basic.valor_inicio, "El valor de inicio se establecio a uno")
		assert_equal(:geometrica, @t_basic.tipo, "Se establecio una regresion geometica")
		assert_equal(0.99, @t_basic.coeficiente, "El coeficiente de partida es 0.99")

		otro = ES::ES.new

		assert_equal(1, otro.valor_inicio, "El valor por defecto de inicio es 1")
		assert_equal(:geometrica, otro.tipo, "La recta seguida por defecto es geometica")
		assert_equal(0.85, otro.coeficiente, "El valor por defecto del coeficiente es de 0.85")
	end

	def test_probabilidad
		aciertos = 0
		fracasos = 0
		repeticiones = 10000
		repeticiones.times do
			if @t_basic.probabilidad
				aciertos += 1
			else
				fracasos += 1
			end
		end

		assert_operator(aciertos, :>=, repeticiones * @t_basic.coeficiente)
		assert_operator(fracasos, :<, repeticiones - repeticiones * @t_basic.coeficiente)
	end

	def test_valores_constructor
		assert_raises(TypeError, "El valor de inicio debe de ser numerico") {ES::ES.new(valor_inicio: "")}
		assert_raises(TypeError, "El valor de inicio debe estar entre 0-1") {ES::ES.new(valor_inicio: 2)}
		assert_raises(TypeError, "El valor de inicio debe estar entre 0-1") {ES::ES.new(valor_inicio: -0.5)}
		assert_raises(TypeError, "Tipo solo admite simbolos") {ES::ES.new(tipo: "asdf")}
		assert_raises(TypeError, "Solo se admite el valor geometica") {ES::ES.new(tipo: :otra_cosa)}
		assert_raises(TypeError, "El coeficiente debe ser de tipo numerico") {ES::ES.new(coeficiente: "ad")}
		assert_raises(TypeError, "El coeficiente debe estar entre 0-1 (exclusive)") {ES::ES.new(coeficiente: 1)}
		assert_raises(TypeError, "El coeficiente debe de estar entre 0-1 (exclusive") {ES::ES.new(coeficiente: 0)}
	end

	def test_enfriamiento
		repeticiones = 100
		start = 1
		anterior = nil
		coeficiente = 0.99
		repeticiones.times do
			@t_basic.enfriar

			start *= coeficiente

			if anterior != nil and (anterior - start) < 0.00001
				start = 0
				assert_equal(0, @t_basic.temperatura, "La temperatura es suficientemente baja como para acabar el bucle")
				break
			end

			assert_equal(start, @t_basic.temperatura, "La temperatura no esta enfriando de forma correcta")
			anterior = start
		end
	end
end