Gem::Specification.new do |s|
  s.name = 'changelogko'
  s.version = File.read('metadata/app-version').strip
  s.summary = 'Manage change logs easily!'
  s.description = 'This is a gem that can manage change logs very easily.'
  s.authors = ['Joseph Nelson Valeros', 'Jenek Michael Sarte']
  s.email = 'tieeeeen1994@gmail.com'
  s.files = ['lib/changelogko.rb', 'lib/changelog/creator.rb', 'lib/changelog/writer.rb',
             'lib/changelog.rb', 'lib/changelog/option_parser.rb', 'lib/releaseko.rb',
             'lib/releaseko/app_version.rb', 'lib/releaseko/changelog_wrapper.rb',
             'lib/releaseko/custom_error.rb', 'lib/releaseko/repository_updater.rb',
             'bin/changelogko', 'bin/releaseko']
  s.homepage = 'https://github.com/tieeeeen1994/changelogko'
  s.license = 'MIT'
  s.executables = %w[changelogko releaseko]
  s.required_ruby_version = '>= 2.5.3'
  s.metadata['rubygems_mfa_required'] = 'true'
end
