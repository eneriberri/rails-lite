require 'json'
require 'webrick'

class Session
  def initialize(req)
		cookie = find_cookie(req)
		@data = cookie.nil? ? {} : JSON.parse(cookie.value)
  end

	def find_cookie(req)
		req.cookies.find do |c|
			c.name == "_rails_lite_app"
		end
	end

  def [](key)
		@data[key]
  end

  def []=(key, val)
		@data[key] = val
  end

  def store_session(res)
		name = "_rails_lite_app"
		val = @data.to_json
		res.cookies << WEBrick::Cookie.new(name, val)
  end
end