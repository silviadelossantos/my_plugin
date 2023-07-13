require File.expand_path('../lib/foreman_plugin_template/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'foreman_plugin_template'
  s.version     = ForemanPluginTemplate::VERSION
  s.metadata    = { "is_foreman_plugin" => "true" }
  s.license     = 'GPL-3.0'
  s.authors     = ['Justia']
  s.email       = ['internaltech@justia.com']
  s.homepage    = 'https://foreman.testito.com'
  s.summary     = 'This foreman plugin allow to manage EBS volumes and volume snapshots'
  # also update locale/gemspec.rb
  s.description = 'you can creat, attach and list volumes, create and list snapshot'

  s.files = Dir['{app,config,db,lib,locale,webpack}/**/*'] + ['LICENSE', 'Rakefile', 'README.md', 'package.json']
  s.test_files = Dir['test/**/*'] + Dir['webpack/**/__tests__/*.js']

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
  s.add_dependency 'deface', '< 2.0'
end
