require 'buildar/tasks'
require 'rake/testtask'

Buildar.conf(__FILE__) do |b|
  b.name = 'lager'
  b.use_version_file  = true
  b.version_filename  = 'VERSION'
  b.use_git           = true
  b.publish[:rubygems] =  true
end

Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end
