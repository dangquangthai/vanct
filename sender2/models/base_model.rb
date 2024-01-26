# frozen_string_literal: true

class BaseModel
  def to_hash
    h = {}
    instance_variables.each { |var| h[var.to_s.delete('@')] = instance_variable_get(var) }
    h
  end
end
