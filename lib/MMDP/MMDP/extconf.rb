#! /usr/bin/env ruby

require 'mkmf'

extension_name = "c_mmdp"

dir_config(extension_name)

create_makefile(extension_name)