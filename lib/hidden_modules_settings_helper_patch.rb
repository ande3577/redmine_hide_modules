require_dependency 'settings_helper'

module HiddenModulesSettingsHelperPatch
  
  def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.class_eval do
          unloadable
      end
  end

  module ClassMethods
  end

  module InstanceMethods
    def plugin_setting_multiselect(plugin, setting, choices, options={})
      setting_values = Setting.send("plugin_#{plugin}")[setting]
      logger.debug "setting_values = #{setting_values.inspect}"
      if(setting_values.is_a?(Hash))
        setting_values = setting_values.keys
      elsif !setting_values.is_a?(Array)
        setting_values = []        
      end
        
      content_tag("label", l(options[:label] || "#{plugin}_settings_#{setting}")) +
        hidden_field_tag("settings[plugin_#{plugin}][#{setting}][]", '').html_safe +
        choices.collect do |choice|
          text, value = (choice.is_a?(Array) ? choice : [choice, choice])
          logger.debug "choice, text, value = #{choice.inspect}, #{text.inspect}, #{value.inspect}"
          content_tag(
            'label',
            check_box_tag(
               "settings[#{setting}][#{value}]",
               value,
               setting_values.include?(value),
               :id => nil
             ) + text.to_s,
            :class => (options[:inline] ? 'inline' : 'block')
           )
        end.join.html_safe
    end
  end
  
end

SettingsHelper.send(:include, HiddenModulesSettingsHelperPatch)