# See https://github.com/sappho/sappho-basics/wiki for project documentation.
# This software is licensed under the GNU Affero General Public License, version 3.
# See http://www.gnu.org/licenses/agpl.html for full details of the license terms.
# Copyright 2012 Andrew Heald.

require 'test/unit'
require 'sappho-basics/module_register'

class ModuleRegisterTest < Test::Unit::TestCase

  def test_module_register
    assert_raises NoMethodError do
      Sappho::ApplicationModuleRegister.new
    end
    modules = Sappho::ApplicationModuleRegister.instance
    assert_nil modules.get(:missing)
    assert !modules.set?(:missing)
    assert modules.set?(:log)
    assert_instance_of Sappho::ApplicationAutoFlushLog, modules.get(:log)
    test1 = TestModule.new
    test2 = TestModule.new
    test3 = TestModule.new
    test4 = TestModule.new
    test5 = Sappho::ModuleRegister.new
    test5.set :test3, test3
    test5.set :test4, test4
    modules.set :test1, test1
    modules.set :test2, test2
    modules.set :test1, test1
    modules.set :test5, test5
    assert_equal test1, modules.get(:test1)
    assert_equal test2, modules.get(:test2)
    assert_equal test5, modules.get(:test5)
    assert modules.set?(:test1)
    assert modules.set?(:test2)
    assert !modules.set?(:test4)
    assert test1.alive
    assert test2.alive
    assert test3.alive
    assert test4.alive
    modules.shutdown
    assert !test1.alive
    assert !test2.alive
    assert !test3.alive
    assert !test4.alive
    assert_instance_of Sappho::ApplicationAutoFlushLog, modules.get(:log)
    assert_equal test1, modules.get(:test1)
    test4.alive = true
    modules.set :notmod, 42
    modules.shutdown
    assert !test4.alive
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
