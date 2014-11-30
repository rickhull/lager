Gem::Specification.new do |s|
  s.name        = 'lager'
  s.summary     = "Sane class-level logging"
  s.author      = "Rick Hull"
  s.homepage    = "http://github.com/rickhull/lager"
  s.license     = 'LGPL'
  s.has_rdoc    = true
  s.description = "Should you use it? Yes."

  s.add_development_dependency "minitest", ["~> 1"]
  s.add_development_dependency  "buildar", ["~> 1"]

  # dynamic setup
  this_dir = File.expand_path('..', __FILE__)
  version_file = File.join(this_dir, 'VERSION')

  # dynamic assignments
  s.version  = File.read(version_file).chomp
  s.files = %w[lager.gemspec
               VERSION
               README.md
               Rakefile
               lib/lager.rb
               test/lager.rb
               examples/foo.rb
               examples/usage.rb
            ]
end
