require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'exposable_attributes', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the exposable_attributes plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the exposable_attributes plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ExposableAttributes'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "exposable_attributes"
    s.version = ExposableAttributes::VERSION
    s.summary = "Make ActiveRecord attributes exposable"
    s.email = "nikolaeff@gmail.com"
    s.homepage = "http://github.com/nikolaeff/exposable_attributes"
    s.description = "Ruby on Rails plugin designed to control ActiveRecord::Base to_xml and to_json methods output"
    s.authors = ['Andrey Nikolaev', 'Maxim Filatov']
    s.files =  FileList["[A-Z]*(.rdoc)", "{generators,lib,rails,tasks}/**/*", "init.rb"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end
