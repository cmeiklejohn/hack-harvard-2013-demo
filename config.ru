$: << 'lib'
require 'rubygems'
require 'bundler'

Bundler.require

require 'rack/static'
require 'rack-rewrite'
require 'rake-pipeline'
require 'rake-pipeline/middleware'

require 'webmachine/adapters/rack'
require 'json'

module HackHarvard
  Projects = [
    { :id => 1,
      :name => "First Project",
      :desc => "We made a project which displays a list of our favorite tweets!",
      :votes => 1 },
    { :id => 2,
      :name => "Best Project",
      :desc => "We made an amazing Ember.js application which displays a ton of data about what's happening in our application!",
      :votes => 100 },
    { :id => 3,
      :name => "Google Mail Clone",
      :desc => "We made an Google Mail clone using GWT.",
      :votes => 5 }
  ]

  Application = Webmachine::Application.new do |app|
    app.configure do |config|
      config.adapter = :Rack
    end
  end

  class ProjectResource < Webmachine::Resource
    def resource_exists?
      @id = request.path_info[:id].to_i
      @project = Projects.detect { |x| x[:id] == @id }
      @project.present?
    end

    def content_types_provided
      [['application/json', :to_json]]
    end

    def to_json
      JSON.generate({ :project => @project })
    end
  end

  class ProjectsListResource < Webmachine::Resource
    def content_types_provided
      [['application/json', :to_json]]
    end

    def to_json
      JSON.generate({ :projects => Projects })
    end
  end

  Application.routes do
    add ['projects', :id], ProjectResource
    add ['projects'], ProjectsListResource
  end
end

Rack::Mime::MIME_TYPES['.woff'] = 'application/x-font-woff'

use Rack::Rewrite do
  rewrite %r{^(.*)\/$}, '$1/index.html'
end

use Rake::Pipeline::Middleware, "Assetfile"

use Rack::Static, :urls => ["/index.html", "/favicon.ico",
                            "/stylesheets", "/javascripts",
                            "/images"], :root => "public"

run HackHarvard::Application.adapter
