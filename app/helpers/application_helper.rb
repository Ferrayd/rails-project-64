# frozen_string_literal: true

module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-danger'
    when :alert then 'alert alert-warning'
    else 'alert alert-secondary'
    end
  end
end
