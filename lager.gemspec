Gem::Specification.new do |s|
  s.name        = 'lager'
  s.summary     = "Sane class-level logging"
  s.description = "Should you use it? Yes."
  s.author      = "Rick Hull"
  s.homepage    = "http://github.com/rickhull/lager"
  s.license     = 'LGPL-3.0'

  s.required_ruby_version = '> 2'

  s.version  = File.read(File.join(__dir__, 'VERSION')).chomp

  # dynamic assignments
  s.files  = %w[lager.gemspec VERSION README.md Rakefile]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['test/**/*.rb']
end
