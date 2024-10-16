module ComponentsHelper
  # Group components by directory
  COMPONENT_VIEW_FOLDERS = {
    "components/layouts/aside" => [:aside, :aside_head, :aside_head],
    "components/layouts/container" => [:container],
    "components/layouts/subheader" => [:subheader],
    "components/layouts/navigation" => [:nav, :nav_item],
    "components/ui" => [:button, :modal], # You can add more components here
    "components/ui/card" => [:card, :card_body, :card_footer, :card_header],
    "components/ui/table" => [:table, :th],
    "components/ui/forms" => [:input, :select]  # Components for form elements
  }.freeze

  COMPONENT_VIEW_FOLDERS.each do |folder, components|
    components.each do |name|
      define_method(name) do |locals = {}, &block|
        locals[:class_name] = ""
        locals[:class_name] = locals.delete(:class) if locals.key?(:class)
        render "#{folder}/#{name}", **locals do
          capture(&block)
        end
      end
    end
  end

  def icon(name, **options)
    # TODO: if name begins with hero, we will use file from components/icons/heroicons path
    render "components/icons/#{name}", css_class: options[:class], data: options[:data]
  end
end