module Releaseko
  class ChangelogWrapper
    def self.perform
      puts 'Running changelogko -r'
      return_value = system("#{'bundle exec ' if defined? Bundler}changelogko -r")
      CustomError.new("changelogko crashed", $?.exitstatus).complain unless return_value
    end
  end
end
