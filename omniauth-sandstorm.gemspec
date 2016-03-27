require File.expand_path('../lib/omniauth-sandstorm/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'omniauth-sandstorm'
  s.version = OmniAuth::Sandstorm::VERSION
  s.authors = ['Steven Dee']
  s.email = ['steve@smartercode.net']
  s.homepage = 'https://github.com/mrdomino/omniauth-sandstorm'
  s.license = 'Apache 2.0'
  s.summary = 'Sandstorm adapter for OmniAuth.'
  s.files = `git ls-files`.split('\n')
  s.test_files = `git ls-files -- {test,spec,features}/*`.split('\n')
  s.executables = `git ls-files bin/*`.split('\n').map{|f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_runtime_dependency 'omniauth', '~> 1.0'
end
