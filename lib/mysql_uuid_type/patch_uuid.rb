require 'uuidtools'

module UUIDTools
  class UUID
    alias_method :id, :raw

    # duck typing activerecord 3.1 dirty hack )
    def gsub *; self; end

    def ==(another_uuid)
      self.to_s == another_uuid.to_s
    end

    def next
      self.class.random_create
    end

    def quoted_id
      s = raw.unpack("H*")[0]
      "x'#{s}'"
    end

    def as_json(options = nil)
      hexdigest.upcase
    end

    def to_param
      hexdigest.upcase
    end

    def to_liquid
      to_param
    end

    def to_json(options=nil)
      "\"#{to_param}\""
    end

    def self.serialize(value)
      case value
      when self
        value
      when String
        parse_string value
      else
        nil
      end
    end

    def bytesize
      16
    end

    def shorten
      ShortUUID.shorten(to_s)
    end

  private

    def self.parse_string(str)
      return nil if str.length == 0
      if str.length == 36
        parse str
      elsif str.length == 32
        parse_hexdigest str
      elsif str.length == 22
        parse ShortUUID.expand(str)
      else
        parse_raw str
      end
    end
  end
end