#! /usr/bin/env ruby

require 'mkmf'

extname = "c_basic_mmdp"

dir_config(extname)

create_makefile(extname)