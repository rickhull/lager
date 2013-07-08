Gem::Specification.new do |s|
  s.name        = 'lager'
  s.summary     = "Sane class-level logging"
  s.author      = "Rick Hull"
  s.homepage    = "http://github.com/rickhull/lager"
  s.license     = 'LGPL'
  s.has_rdoc    = true
  s.description = "Should you use it? Yes."

  s.add_development_dependency "minitest", [">= 0"]
  s.add_development_dependency  "buildar", ["~> 1.4"]

  # dynamic setup
  this_dir = File.expand_path('..', __FILE__)
  version_file = File.join(this_dir, 'VERSION')
  manifest_file = File.join(this_dir, 'MANIFEST.txt')

  # dynamic assignments
  s.version  = File.read(version_file).chomp
  s.files = File.readlines(manifest_file).map { |f| f.chomp }
end
