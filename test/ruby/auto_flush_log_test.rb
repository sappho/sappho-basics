# See https://github.com/sappho/sappho-basics/wiki for project documentation.
# This software is licensed under the GNU Affero General Public License, version 3.
# See http://www.gnu.org/licenses/agpl.html for full details of the license terms.
# Copyright 2012 Andrew Heald.

require 'test/unit'
require 'stringio'
require 'sappho-basics/auto_flush_log'

class AutoFlushLogTest < Test::Unit::TestCase

  include Sappho::LogUtilities

  def test_logging
    file = StringIO.new
    Sappho::ApplicationAutoFlushLog.file file
    assert_raises NoMethodError do
      Sappho::ApplicationAutoFlushLog.new
    end
    ENV['application.log.level'] = 'debug'
    ENV['application.log.detail'] = 'test'
    log = Sappho::ApplicationAutoFlushLog.instance
    assert log.debug?
    log.debug 'Test 1'
    log.info 'Test 2'
    log.warn 'Test 3'
    begin
      raise 'Test 4'
    rescue => error
      log.error error
    end
    begin
      raise 'Test 5'
    rescue => error
      log.fatal error
    end
    assert_match /DEBUG Test 1/m, file.string
    assert_match /INFO Test 2/m, file.string
    assert_match /WARN Test 3/m, file.string
    assert_match /ERROR error! Test 4/m, file.string
    assert_match /ERROR .+\/auto_flush_log_test.rb:\d+:in `test_logging'/m, file.string
    assert_match /FATAL error! Test 5/m, file.string
    assert_match /FATAL .+\/auto_flush_log_test.rb:\d+:in `test_logging'/m, file.string
    assert_equal '61 62 63 78 79 7a ', hexString('abcxyz'.unpack('c*'))
  end

end
