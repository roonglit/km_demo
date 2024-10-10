module Components
  module IconHelper
    def icon(name, **options)
      # TODO: if name begins with hero, we will use file from components/icons/heroicons path
      render "components/icons/#{name}", css_class: options[:class], data: options[:data]
    end
  end
end