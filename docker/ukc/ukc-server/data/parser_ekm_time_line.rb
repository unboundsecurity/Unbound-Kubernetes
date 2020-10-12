require 'fluent/plugin/parser'

module Fluent::Plugin
  class TimeKeyValueParser < Parser
    Fluent::Plugin.register_parser('ekm_time_line', self)

    config_param :delimiter, :string, default: ' '

    config_param :time_format, :string, default: '%Y-%m-%d %H:%M:%S,%L'

    def configure(conf)
      super

      if @delimiter.length != 1
        raise ConfigError, "delimiter must be a single character. #{@delimiter} is not."
      end

      # `TimeParser` class is already available.
      # It takes a single argument as the time format
      # to parse the time string with.
      @time_parser = Fluent::TimeParser.new(@time_format)
    end

    def parse(text)
      #time, key_values = text.split(' ', 2)
      time = text[0..23]
      key_values = text[23..-1]
      time = @time_parser.parse(time)
      record = {}
      #key_values.split(@delimiter).each do |kv|
      #  k, v = kv.split('=', 2)
      #  record[k] = v
      #end
      record['message'] = key_values
      record['server'] = `hostname`.strip
      yield time, record
    end
  end
end
