#! /usr/bin/env ruby

require 'minitest/autorun'
require_relative '../../lib/ES/ES/ES'

class TestES < MiniTest::Test
	def setup
		@t_basic = ES::ES.new(100, 0.85)
	end

	def test_constructor
		assert_equal(100, @t_basic.temperatura, "El valor de inicio se establecio a uno")
		assert_equal(0.85, @t_basic.coeficiente, "El coeficiente de partida es 0.99")
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

		assert_equal(aciertos, repeticiones)
		assert_equal(fracasos, 0)

		aciertos = 0
		fracasos = 0

		@t_basic.enfriar
		@t_basic.enfriar
		@t_basic.enfriar
		@t_basic.enfriar
		@t_basic.enfriar

		repeticiones.times do
			if @t_basic.probabilidad
				aciertos += 1
			else
				fracasos += 1
			end
		end

		assert_operator(aciertos, :<, fracasos, "No puede haber tantos aciertos con una probabilidad de #{@t_basic.coeficiente}")
	end

	def test_valores_constructor
		assert_raises(TypeError, "La temperatura debe de ser un valor numerico") {ES::ES.new("a", 0.5)}
		assert_raises(TypeError, "El coeficiente debe de ser un valor numerico") {ES::ES.new(3, "a")}
		assert_raises(TypeError, "La temperatura no puede ser negativa") {ES::ES.new(-5, 0.23)}
		assert_raises(TypeError, "La temperatura no puede menor que uno") {ES::ES.new(0.999, 0.1)}
		assert_raises(TypeError, "El coeficiente no pude ser cero") {ES::ES.new(1, 0)}
		assert_raises(TypeError, "El coeficiente no puede ser menor que cero") {ES::ES.new(1, -0.1)}
		assert_raises(TypeError, "El coeficiente no puede ser uno") {ES::ES.new(2, 1)}
		assert_raises(TypeError, "El coeficiente no puede ser mayor que uno") {ES::ES.new(1, 1.25)}
	end

	def test_enfriamiento
		repeticiones = 100
		start = 100

		coeficiente = 0.85
		repeticiones.times do
			@t_basic.enfriar

			start *= coeficiente

			assert_equal(start, @t_basic.temperatura, "La temperatura no esta enfriando de forma correcta")
		end
	end
end
