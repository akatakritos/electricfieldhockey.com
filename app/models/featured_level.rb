class FeaturedLevel < Level

  attr_accessor :label

  def self.random(options={})
    label = options.fetch(:label){ "Random" }
    l = super(options)
    l.label = label unless l.nil?
    l
  end

  def self.newest(options={})
    label = options.fetch(:label) { "Newest" }
    l = super()
    l.label = label unless l.nil?
    l
  end

  def self.hardest(options={})
    label = options.fetch(:label) { "Hardest" }
    l = super()
    l.label = label unless l.nil?
    l
  end
end
