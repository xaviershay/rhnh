class UndoItem < ActiveRecord::Base
  def loaded_data
    begin
      @loaded_data ||= YAML.load(data)
    rescue
      raise "Invalid undo data for #{self.class},#{self.id}"
    end
  end

  def process!
    raise("#process must be implemented by subclasses")
  end
end
