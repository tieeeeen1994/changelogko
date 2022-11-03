module Releaseko
  class RepositoryUpdater
    def self.perform
      puts 'Updating remote repository'
      system('git add CHANGELOG.md metadata/app-version changelogs/*')
      system('git commit -m "Bump app version and release changelogs"')
      system('git push')
    end

    def self.set_to_push
      ['-p', '--push'].include?(ARGV[2])
    end
  end
end
