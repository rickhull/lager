require 'buildar'
require 'rake/testtask'

Buildar.new do |b|
  b.gemspec_file = 'lager.gemspec'
  b.version_file = 'VERSION'
  b.use_git           = true
end

task default: %w[test]

desc "Run tests"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end
