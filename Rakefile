require 'rake/testtask'

desc "Run tests"
Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
  t.warning = true
end

task default: %w[test]

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'lager.gemspec'
    b.version_file = 'VERSION'
    b.use_git           = true
  end
rescue LoadError
  warn "buildar unavailble"
end
