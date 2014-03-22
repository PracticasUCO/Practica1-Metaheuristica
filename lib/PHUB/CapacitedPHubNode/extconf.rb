#! /usr/bin/env ruby
# encoding: utf-8

# Loads mkmf which is used to make makefiles for Ruby extensions
require 'mkmf'

# Give it a name
extension_name = 'c_basic_capacited_phub_node'

# The destination
dir_config(extension_name)

# Do the work
create_makefile(extension_name)  
