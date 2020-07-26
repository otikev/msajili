class EventObject

  attr_accessor :id, :title, :description,:allDay , :start, :end, :url

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end