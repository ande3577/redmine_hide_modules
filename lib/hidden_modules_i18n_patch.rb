require_dependency 'redmine/i18n'

module HiddenModulesI18nPatch
  
  def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
          unloadable
          alias_method_chain :l_or_humanize, :check_for_project_module
      end
  end

  module ClassMethods
  end

  module InstanceMethods
    def l_or_humanize_with_check_for_project_module(s, options={})
      if options[:prefix] == "project_module_"
        if !@project.nil? and !HiddenModulesI18nPatch::display_module?(@project, s)
          return "";
        end
      end
      l_or_humanize_without_check_for_project_module(s, options)
    end
    
  end
  
  def self.display_module?(project, m)
    hidden_modules = Setting.send("plugin_redmine_hide_modules")[:hidden_projects_modules]
    if(hidden_modules.is_a?(Hash))
      hidden_modules = hidden_modules.keys
    elsif !hidden_modules.is_a?(Array)
      hidden_modules = []        
    end
    
    if project.module_enabled?(m) || !hidden_modules.include?(m.to_s()) || User.current().admin?
      return true
    end
    false
  end
  
end

Redmine::I18n.send(:include, HiddenModulesI18nPatch)