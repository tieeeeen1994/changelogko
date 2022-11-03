class Changelog::Creator
  def self.call(options)
    changelog = Changelog.new(options, :options)
    changelog.validate!
    changelog.save
  end
end
