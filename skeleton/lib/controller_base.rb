require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params
  # before_action :already_built?
  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end
  
  # def already_built?
  #   raise "Already rendered" if @already_built_response
  # end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already rendered" if @already_built_response
    @res['Location'] = url
    @res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = 'text/html')
    raise "Already rendered" if @already_built_response
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  
  def render(template_name) #new, edit, index
    # dir_path = File.dirname(__FILE__)
    
    dir_path = File.expand_path( Dir.pwd)
    
    template_path = File.join(dir_path,"views","#{self.class}".underscore ,"#{template_name}.html.erb") # " / "

    template_code = File.read(template_path)
    
    render_content(ERB.new(template_code).result(binding))
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

