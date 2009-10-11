module LogParser
  class Template
    attr_reader :fields, :regexp

    def initialize(pattern)
      build_regexp(pattern)
    end

    def build_regexp(pattern)
      @fields = []
      @regexp = Regexp.new("\\A" << Regexp.escape(pattern).gsub(/:([a-z_][a-z0-9_]*)/){
        @fields << $1.to_sym
        "(.*?)"
      } << "\\Z" )
    end

    def apply(str)
      if matches = str.match(@regexp)
        hash = {}
        @fields.each_with_index do |key, i|
          hash[key] = matches[i+1]
        end
        return hash
      else
        return nil
      end
    end
  end
end
