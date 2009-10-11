require 'date'

module LogParser
  class Line
    def initialize(template, raw)
      @template = template
      @raw = raw.strip
    end

    def raw_fields
      @raw_fields ||= @template.apply(@raw)
    end

    def host
      @host ||= decode_string(raw_fields[:host])
    end

    def domain
      @domain ||= decode_string(raw_fields[:domain])
    end

    def timestamp
      @timestamp ||= DateTime.strptime(raw_fields[:timestamp], '%d/%b/%Y:%H:%M:%S %Z')
    end

    def verb
      @verb ||= raw_fields[:verb].downcase.to_sym
    end

    def path
      @path ||= raw_fields[:path]
    end

    def protocol
      @protocol ||= raw_fields[:protocol]
    end

    def status
      @status ||= raw_fields[:status].to_i
    end

    def bytes
      @bytes ||= raw_fields[:bytes].to_i
    end

    def referrer
      @referrer ||= decode_string(raw_fields[:referrer])
    end

    def user_agent
      @user_agent ||= decode_string(raw_fields[:user_agent])
    end

    def time_taken
      @time_taken ||= raw_fields[:time_taken] ? raw_fields[:time_taken].to_f : nil
    end

  private

    def decode_string(str)
      case str
      when '-', ''
        return nil
      else
        return str
      end
    end
  end
end
