module Releaseko
  # Wrapper for Changelogko.
  class ChangelogWrapper
    def self.perform
      puts 'Running changelogko -r'
      return_value = system("#{'bundle exec ' if defined? Bundler}changelogko -r")
      CustomError.new('changelogko crashed', $CHILD_STATUS.exitstatus).complain unless return_value
    end
  end
end
