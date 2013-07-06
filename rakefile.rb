require 'rubygems/package_task'
require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.pattern = 'test/*.rb'
end

PROJECT_ROOT = File.dirname(__FILE__)
PROJECT_NAME = File.split(PROJECT_ROOT).last
VERSION_FILE = File.join(PROJECT_ROOT, 'VERSION')
MANIFEST_FILE = File.join(PROJECT_ROOT, 'MANIFEST.txt')

def version
  File.read(VERSION_FILE).chomp
end

task :version do
  puts "#{PROJECT_NAME} #{version}"
end

task :tag => [:test] do
  tagname = "v#{version}"
  sh "git tag -a #{tagname} -m 'auto-tagged #{tagname} by Rake'"
  sh "git push origin --tags"
end

def manifest
  File.readlines(MANIFEST_FILE).map { |line| line.chomp }
end

task :manifest do
  puts manifest.join("\n")
end

task :build => [:test, :bump_build] do
  spec = Gem::Specification.new do |s|
    # Static assignments
    s.name        = PROJECT_NAME
    s.summary     = "Sane class-level logging"
    s.description = "Should you use it? Yes."
    s.authors     = ["Rick Hull"]
    s.email       = "rick@cloudscaling.com"
    s.homepage    = "http://github.com/rickhull/lager"
    s.licenses    = ['LGPL']

    # Dynamic assignments
    s.files       = manifest
    s.version     = version
    s.date        = Time.now.strftime("%Y-%m-%d")

#    s.add_runtime_dependency  "rest-client", ["~> 1"]
#    s.add_runtime_dependency         "json", ["~> 1"]
    s.add_development_dependency "minitest", [">= 0"]
    s.add_development_dependency     "rake", [">= 0"]
  end

  # we're definining the task at runtime, rather than requiretime
  # so that the gemspec will reflect any version bumping since requiretime
  #
  Gem::PackageTask.new(spec).define
  Rake::Task["package"].invoke
end

# e.g. bump(:minor, '1.2.3') #=> '1.3.0'
# only works for integers delimited by periods (dots)
#
def bump(position, version)
  pos = [:major, :minor, :patch, :build].index(position) || position
  places = version.split('.')
  raise "bad position: #{pos} (for version #{version})" unless places[pos]
  places.map.with_index { |place, i|
    if i < pos
      place
    elsif i == pos
      place.to_i + 1
    else
      0
    end
  }.join('.')
end

def write_version new_version
  File.open(VERSION_FILE, 'w') { |f| f.write(new_version) }
end

[:major, :minor, :patch, :build].each { |v|
  task "bump_#{v}" do
    old_version = version
    new_version = bump(v, old_version)
    puts "bumping #{old_version} to #{new_version}"
    write_version new_version
    sh "git add VERSION"
    sh "git commit -m 'rake bump_#{v} to #{new_version}'"
  end
}
task :bump => [:bump_patch]

task :verify_publish_credentials do
  creds = '~/.gem/credentials'
  fp = File.expand_path(creds)
  raise "#{creds} does not exist" unless File.exists?(fp)
  raise "can't read #{creds}" unless File.readable?(fp)
end

task :publish => [:verify_publish_credentials] do
  fragment = "-#{version}.gem"
  pkg_dir = File.join(PROJECT_ROOT, 'pkg')
  Dir.chdir(pkg_dir) {
    candidates = Dir.glob "*#{fragment}"
    case candidates.length
    when 0
      raise "could not find .gem matching #{fragment}"
    when 1
      sh "gem push #{candidates.first}"
    else
      raise "multiple candidates found matching #{fragment}"
    end
  }
end

task :gitpush do
  # may prompt
  sh "git push origin"
  # this kills the automation
  # consider a timeout?
end

task :release => [:build, :tag, :publish, :gitpush]
task :release_patch => [:bump_patch, :release]
task :release_minor => [:bump_minor, :release]
task :release_major => [:bump_major, :release]
