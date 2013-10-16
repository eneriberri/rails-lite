require 'erb'
require 'active_support/core_ext'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
		@req = req
		@res = res
		@params = Params.new(req, route_params)
  end

  def session
		@session ||= Session.new(@req)
  end

  def already_rendered?
		@already_built_response
  end

  def redirect_to(url)
		@res.status = 302
		@res.header['location'] = url
		@already_built_response = true
		session.store_session(@res)
  end

  def render_content(content, type)
		@res.content_type = type
		@res.body = content
		@already_built_response = true
		session.store_session(@res)
  end

  def render(template_name)
		controller_name = self.class.name.underscore
		f = File.read("views/#{controller_name}/#{template_name}.html.erb")
		content = ERB.new(f).result(binding)

		render_content(content, 'text/html')
  end

  def invoke_action(name)
  end
end
