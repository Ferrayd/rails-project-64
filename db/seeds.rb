# frozen_string_literal: true

%w[Новости Развлечения Спорт Технологии].map { |name| Category.create!(name: name) }

User.create!(email: 'admin@example.com', password: 'password') unless User.exists?

Rails.logger.debug 'Сущности успешно созданы!'
