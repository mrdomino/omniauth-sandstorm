Gem::Specification.new do |s|
  s.name = 'omniauth-sandstorm'
  s.version = File.read('lib/omniauth-sandstorm/version.rb')[/VERSION = '(.*)'/, 1]
  s.authors = ['Steven Dee']
  s.email = ['steve@smartercode.net']
  s.homepage = 'https://github.com/mrdomino/omniauth-sandstorm'
  s.license = 'Apache 2.0'
  s.summary = 'Sandstorm adapter for OmniAuth.'
  s.description = 'Adapter to enable OmniAuth login for Sandstorm apps.'
  s.files = Dir['{lib/**/*,test/**/*}'] +
              %w(LICENSE README.md omniauth-sandstorm.gemspec)
  s.require_path = 'lib'
  s.add_runtime_dependency 'omniauth', '~> 1.0'
  s.add_development_dependency 'bundler', '~> 1.11.2'
end
