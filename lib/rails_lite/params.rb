require 'uri'
require 'json'

class Params
  def initialize(req, route_params)
		@params = {}
		if req.body
			@params = parse_www_encoded_form(req.body)
		end
		if req.query_string
			@params = parse_www_encoded_form(req.query_string)
		end
  end

  def [](key)
		@params[key]
  end

  def to_s
		@params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
		params = {}

		key_val_arr = URI.decode_www_form(www_encoded_form)
		key_val_arr.each do |nested_key, val|
			nested = params
			keys = parse_key(nested_key)
			count = 0
			keys.each do |key|
				if count == keys.length - 1
					nested[key] = val
				else
					nested[key] ||= {}
					nested = nested[key]
					count += 1
				end
			end
		end

		params
  end


  def parse_key(key)
		nested = key.split(/\]\[|\[|\]/)
		return [nested.last] if nested.first == ""
		return nested
  end
end
