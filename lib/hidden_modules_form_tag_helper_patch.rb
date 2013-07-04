module HiddenModulesFormTagHelperPatch
  
  def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
          unloadable
          alias_method_chain :check_box_tag, :check_for_project_module
      end
  end

  module ClassMethods
  end

  module InstanceMethods
    def check_box_tag_with_check_for_project_module(name, value = "1", checked = false, options = {})
      if name == 'enabled_module_names[]' or name == 'project[enabled_module_names][]'
        if !HiddenModulesI18nPatch::display_module?(@project, value)
          return ""
        end
      end
      return check_box_tag_without_check_for_project_module(name, value, checked, options)
    end
  end
  
end

ActionView::Helpers::FormTagHelper.send(:include, HiddenModulesFormTagHelperPatch)