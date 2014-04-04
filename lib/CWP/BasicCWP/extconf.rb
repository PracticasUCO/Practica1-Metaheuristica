#! /usr/bin/env ruby
# encoding: utf-8

# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

$CFLAGS="-fbounds-check -fdefault-inline -ffast-math -ffloat-store -fforce-addr -ffunction-cse -finline"

# Give it a name
extension_name = 'c_basic_cwp'

# The destination
dir_config(extension_name)

# Do the work
create_makefile(extension_name)  
