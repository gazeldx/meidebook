require 'rubygems'
require 'bundler'

Bundler.require
Dir.glob("#{Sinatra::Application.settings.root}/{lib,helpers,uploaders}/*.rb").each { |file| require file }
require './controllers/application_controller'

# 说明：用于把多个css或js文件压缩到一个文件中，类似rails的asset pipline。采用sprockets实现。只需要执行 $ rake assets:compile 就可以了
namespace :assets do
  desc 'compile assets'
  task :compile => [:compile_js, :compile_css] do
  end

  desc 'compile javascript assets'
  task :compile_js do
    sprockets = ApplicationController.settings.sprockets
    asset     = sprockets['application.js']
    outpath   = File.join(ApplicationController.settings.assets_path, '')
    outfile   = Pathname.new(outpath).join('application.min.js') # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled js assets"
  end

  desc 'compile css assets'
  task :compile_css do
    sprockets = ApplicationController.settings.sprockets
    asset     = sprockets['application.css']
    outpath   = File.join(ApplicationController.settings.assets_path, '')
    outfile   = Pathname.new(outpath).join('application.min.css') # may want to use the digest in the future?

    FileUtils.mkdir_p outfile.dirname

    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
    puts "successfully compiled css assets"
  end
  # todo: add :clean_all, :clean_css, :clean_js tasks, invoke before writing new file(s)
end