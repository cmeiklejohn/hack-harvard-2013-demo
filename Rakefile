$: << 'lib'
require 'bundler/setup'
require 'rake-pipeline'
require 'pathname'

namespace :assets do
  task :precompile do
    Rake::Pipeline::Project.new("Assetfile").invoke
  end
end

task :jshint do
  jsfiles = Dir["assets/javascripts/app/**/*.js"]
  result = system "jshint", "--config" , ".jshintrc", *jsfiles
  exit result || 1
end
