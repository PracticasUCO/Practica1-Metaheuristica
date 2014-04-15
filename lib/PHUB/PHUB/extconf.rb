#! /usr/bin/env ruby

require 'mkmf'

extension_name = "c_phub"

#$CFLAGS="-fbounds-check -fdefault-inline -ffast-math -ffloat-store -fforce-addr -ffunction-cse -finline"

dir_config(extension_name)
create_makefile(extension_name)
