# See https://github.com/sappho/sappho-basics/wiki for project documentation.
# This software is licensed under the GNU Affero General Public License, version 3.
# See http://www.gnu.org/licenses/agpl.html for full details of the license terms.
# Copyright 2012 Andrew Heald.

require 'singleton'
require 'sappho-basics/auto_flush_log'

module Sappho

  class ModuleRegister

    include Singleton

    def initialize
      @modules = { :log => AutoFlushLog.instance }
    end

    def set name, mod
      @modules[name] = mod
    end

    def get name
      @modules[name]
    end

    def set? name
      @modules.has_key? name
    end

    def shutdown
      each { |mod| mod.shutdown }
    end

    def each
      @modules.each do |name, mod|
        begin
          yield mod
        rescue
        end
      end
    end

  end

end
