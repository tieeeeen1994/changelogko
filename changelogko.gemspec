# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'changelogko'
  s.version = File.read('metadata/app-version').strip
  s.summary = 'Manage changelogs easily!'
  s.description = 'This is a gem that can manage changelogs very easily.'
  s.authors = ['Joseph Nelson Valeros', 'Jenek Michael Sarte']
  s.email = ['valerosjoseph@gmail.com', 'tieeeeen1994@gmail.com']
  s.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[.git .github Gemfile .vscode]) ||
        f.end_with?(*%w[.gem .yml .gitignore])
    end
  end
  s.homepage = 'https://github.com/tieeeeen1994/changelogko'
  s.license = 'MIT'
  s.executables = %w[changelogko releaseko cko rko]
  s.required_ruby_version = '>= 3.2.2'
  s.metadata['rubygems_mfa_required'] = 'true'
end
