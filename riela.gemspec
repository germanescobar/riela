Gem::Specification.new do |s|
  s.name            = 'riela'
  s.version         = '0.1.0'
  s.licenses        = ['MIT']
  s.summary         = 'A pure Ruby Web Server'
  s.authors         = ['Germán Escobar']
  s.files           = Dir['lib/**/*.rb']

  s.add_runtime_dependency 'rack', '~> 1.0'
end