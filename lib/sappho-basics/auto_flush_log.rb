# See https://github.com/sappho/sappho-basics/wiki for project documentation.
# This software is licensed under the GNU Affero General Public License, version 3.
# See http://www.gnu.org/licenses/agpl.html for full details of the license terms.
# Copyright 2012 Andrew Heald.

module Sappho

  require 'singleton'
  require 'thread'
  require 'logger'

  class AutoFlushLog

    LOG_LEVELS = {
        'debug' => Logger::DEBUG,
        'info' => Logger::INFO,
        'warn' => Logger::WARN,
        'error' => Logger::ERROR,
        'fatal' => Logger::FATAL
    }
    LOG_DETAIL = {
        'message' => proc { |severity, datetime, progname, message| "#{message}\n" },
        'test' => proc { |severity, datetime, progname, message| "#{severity} #{message}\n" }
    }

    def initialize file, level, detail
      @mutex = Mutex.new
      @log = Logger.new file
      @log.level = LOG_LEVELS.has_key?(level) ? LOG_LEVELS[level] : Logger::INFO
      @log.formatter = LOG_DETAIL[detail] if LOG_DETAIL.has_key?(detail)
    end

    def debug message
      @mutex.synchronize do
        @log.debug message
        $stdout.flush
      end if @log.debug?
    end

    def info message
      @mutex.synchronize do
        @log.info message
        $stdout.flush
      end if @log.info?
    end

    def warn message
      @mutex.synchronize do
        @log.warn message
        $stdout.flush
      end if @log.warn?
    end

    def error error
      @mutex.synchronize do
        @log.error "error! #{error.message}"
        error.backtrace.each { |error| @log.error error }
        $stdout.flush
      end if @log.error?
    end

    def fatal error
      @mutex.synchronize do
        @log.fatal "error! #{error.message}"
        error.backtrace.each { |error| @log.fatal error }
        $stdout.flush
      end if @log.fatal?
    end

    def debug?
      @log.debug?
    end

  end

  class ApplicationAutoFlushLog < AutoFlushLog

    include Singleton

    @@file = nil

    def AutoFlushLog.file file
      @@file = file
    end

    def initialize
      unless @@file
        filename = ENV['application.log.filename']
        mode = File.exists?(filename) ? 'a' : 'w' if filename
        @@file = filename ? File.open(filename, mode) : $stdout
      end
      super @@file, ENV['application.log.level'], ENV['application.log.detail']
    end

  end

  module LogUtilities

    def hexString bytes
      (bytes.collect {|byte| "%02x " % (byte & 0xFF)}).join
    end

  end

end
