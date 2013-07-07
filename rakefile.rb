require 'buildar/tasks'
require 'rake/testtask'

Buildar.conf(__FILE__) do |b|
  b.name = 'lager'
  b.use_version_file  = true
  b.version_filename  = 'VERSION'
  b.use_manifest_file = true
  b.manifest_filename = 'MANIFEST.txt'
  b.use_git           = true
  b.publish[:rubygems] =  true
  b.gemspec.summary     = "Sane class-level logging"
  b.gemspec.description = "Should you use it? Yes."
  b.gemspec.authors     = ["Rick Hull"]
  b.gemspec.homepage    = "http://github.com/rickhull/lager"
  b.gemspec.licenses    = ['LGPL']

  b.gemspec.add_development_dependency "minitest", [">= 0"]
  b.gemspec.add_development_dependency  "buildar", ["~> 1.2"]
end

Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end
