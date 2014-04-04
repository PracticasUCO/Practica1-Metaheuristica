#! /usr/bin/env ruby

require 'mkmf'

$CFLAGS="-fbounds-check -fdefault-inline -ffast-math -ffloat-store -fforce-addr -ffunction-cse -finline"

extname = "c_basic_mmdp"

dir_config(extname)

create_makefile(extname)