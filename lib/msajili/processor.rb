module Msajili

  class Processor
    require 'active_support'
    require 'base64'
    include ActiveSupport::JSON

    attr_reader :response
    attr_reader :compressed_response

    def initialize(action,params)
      @action = action
      @params = params
    end

    def process
      read_file(@params)

      @response = Hash.new
      @response[:operation] = @action
      @response[:response_code] = Constants::RESPONSE_ERROR #if not changed we assume an error occurred
      @response[:android_app_version] = Constants::MINIMUM_SUPPORTED_ANDROID_APP_VERSION
      sync_log_version = Setting.get_sync_log_version
      if !sync_log_version
        Setting.set_sync_log_version(1)
        sync_log_version = Setting.get_sync_log_version
      end
      @response[:sync_log_version] = sync_log_version.value.to_i

      case @action
        when 'ping', 'sync', 'import_sync', 'data'
          process_without_authentication
        else
          authenticate_then_process
      end

      j_response = ActiveSupport::JSON.encode(@response)
      puts '**********************'
      puts "@response : #{@response}"
      puts "Uncompressed size: #{j_response.size}"
      @compressed_response = Zlib::Deflate.deflate(j_response)
      puts "Compressed size: #{ @compressed_response.size}"
      puts '**********************'
    end

    private

    def get_payload
      case @action
        when 'sync'
          return sync
        when 'import_sync'
          return import_sync
        when 'data'
          return data
      end
    end

    def data
      records = JSON.parse('[]')
      data_to_fetch = @json_data['data_to_fetch']
      data_to_fetch.each do |params|
        id = params['id'].to_i
        type = params['type']
        case type
          when Constants::RECORD_CATEGORY
            fetched_object = JSON.parse('{}')
            fetched_object['id'] = id
            fetched_object['type'] = type
            fetched_object['data'] = Category.get_json(id)
            records.push(fetched_object)
          when Constants::RECORD_COMPANY
            fetched_object = JSON.parse('{}')
            fetched_object['id'] = id
            fetched_object['type'] = type
            fetched_object['data'] = Company.get_json(id)
            records.push(fetched_object)
          when Constants::RECORD_JOB
            fetched_object = JSON.parse('{}')
            fetched_object['id'] = id
            fetched_object['type'] = type
            fetched_object['data'] = Job.get_json(id)
            records.push(fetched_object)
          when Constants::RECORD_JOB_FIELD
            fetched_object = JSON.parse('{}')
            fetched_object['id'] = id
            fetched_object['type'] = type
            fetched_object['data'] = JobField.get_json(id)
            records.push(fetched_object)
          when Constants::RECORD_JOB_STAT
            fetched_object = JSON.parse('{}')
            fetched_object['id'] = id
            fetched_object['type'] = type
            fetched_object['data'] = JobStat.get_json(id)
            records.push(fetched_object)
        end
      end
      response = JSON.parse('{}')
      response['records'] = records
    end

    def sync
      sync_pointer = @json_data['sync_pointer'].to_i
      return SyncLog.build(sync_pointer,100)
    end

    def import_sync
      record_type = @json_data['record_type'].to_i
      current_id = @json_data['current_id'].to_i
      return SyncLog.build_import(record_type,current_id,250)
    end

    def process_without_authentication
      @response[:response_code] = Constants::RESPONSE_SUCCESS
      payload = get_payload
      if payload
        @response[:payload] = payload
      end
    end

    def authenticate_then_process
      @user = User.authenticate_session(@json_data)
      if @user
        @response[:response_code] = Constants::RESPONSE_SUCCESS
        payload = get_payload
        if payload
          @response[:payload] = payload
        end
      else
        @response[:response_code] = Constants::RESPONSE_AUTH_ERROR
      end
    end

    def read_file(params)
      data = params[:syncdata].tempfile
      data_compressed = ''
      File.open(data, 'r') do |file|
        file.each do |line|
          data_compressed.concat(line)
        end
      end
      @json_data = JSON.parse(data_compressed)
      puts '*****************'
      puts "params -: #{@json_data}"
      puts '*****************'
    end

  end

end
