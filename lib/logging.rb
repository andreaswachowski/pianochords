# frozen_string_literal: true

require 'logger'

#  See http://stackoverflow.com/questions/917566/ruby-share-logger-instance-among-module-classes
module Logging
  def logger
    Logging.logger
  end

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def configure_logger(logtarget)
      @logger = Logger.new(logtarget)
      @logger
    end
  end
end
