#! /usr/bin/env ruby

require 'mkmf'

$CFLAGS="-fbounds-check -fdefault-inline -ffast-math -ffloat-store -fforce-addr -ffunction-cse -finline"

extension_name = "TSP"

dir_config(extension_name)
create_makefile(extension_name)