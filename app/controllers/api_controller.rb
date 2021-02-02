class ApiController < ApplicationController
  require 'utils'
  require 'msajili'

  skip_before_filter  :verify_authenticity_token

  def ping
    processor = Msajili::Processor.new('ping', params)
    processor.process
    response = processor.compressed_response
    send_data response
  end

  def sync
    processor = Msajili::Processor.new('sync', params)
    processor.process
    response = processor.compressed_response
    send_data response
  end

  def import_sync
    processor = Msajili::Processor.new('import_sync', params)
    processor.process
    response = processor.compressed_response
    send_data response
  end

  def data
    processor = Msajili::Processor.new('data', params)
    processor.process
    response = processor.compressed_response
    send_data response
  end
end
