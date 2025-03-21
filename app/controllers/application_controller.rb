# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&)
    locale = I18n.available_locales.include?(params[:locale]) ? params[:locale] : I18n.default_locale

    I18n.with_locale(locale, &)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
