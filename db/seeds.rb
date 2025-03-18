# frozen_string_literal: true

%w[Новости Развлечения Спорт Технологии].map { |name| Category.create!(name: name) }

Rails.logger.debug 'Сущности успешно созданы!'
