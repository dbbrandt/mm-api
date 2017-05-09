module Fae
  module  FaeHelper

    def fae_add_button(item, add_path = nil, *custom_attrs)
      return if item.blank?
      add_path ||= polymorphic_path([main_app, fae_scope, item.try(:fae_parent), item])
      attrs = { }
      attrs.deep_merge!(custom_attrs[0]) if custom_attrs.present?
      link_to add_path, attrs do
        concat content_tag :i, nil, class: 'add-button', style: 'padding: 5px 3px 5px 10px;'
      end
    end
  end
end
