# See https://github.com/sappho/sappho-basics/wiki for project documentation.
# This software is licensed under the GNU Affero General Public License, version 3.
# See http://www.gnu.org/licenses/agpl.html for full details of the license terms.
# Copyright 2012 Andrew Heald.

require 'test/unit'
require 'sappho-basics/module_register'

class ModuleRegisterTest < Test::Unit::TestCase

  def test_module_register
    assert_raises NoMethodError do
      Sappho::ModuleRegister.new
    end
    modules = Sappho::ModuleRegister.instance
    assert_nil modules.get(:missing)
    assert !modules.set?(:missing)
    assert modules.set?(:log)
    assert_instance_of Sappho::AutoFlushLog, modules.get(:log)
    test1 = TestModule.new
    test2 = TestModule.new
    modules.set :test1, test1
    modules.set :test2, test2
    modules.set :test1, test1
    assert_equal test1, modules.get(:test1)
    assert_equal test2, modules.get(:test2)
    assert modules.set?(:test1)
    assert modules.set?(:test2)
    assert test1.alive
    assert test2.alive
    modules.shutdown
    assert !test1.alive
    assert !test2.alive
    assert_instance_of Sappho::AutoFlushLog, modules.get(:log)
    assert_equal test1, modules.get(:test1)
    assert_equal test2, modules.get(:test2)
    test1.alive = true
    test2.alive = true
    modules.shutdown
    assert !test1.alive
    assert !test2.alive
    assert_instance_of Sappho::AutoFlushLog, modules.get(:log)
    assert_equal test1, modules.get(:test1)
    assert_equal test2, modules.get(:test2)
  end

  class TestModule

    attr_accessor :alive

    def initialize
      @alive = true
    end

    def shutdown
      @alive = false
      raise 'ignored error'
    end

  end

end
