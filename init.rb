require 'redmine'
require_dependency 'hidden_modules_settings_helper_patch'
require_dependency 'hidden_modules_form_tag_helper_patch'
require_dependency 'hidden_modules_i18n_patch'

Redmine::Plugin.register :redmine_hide_modules do
  # placholder to keep the hash from being removed
  settings :default => {:hidden_projects_modules => "", :dummy_setting => ""}, :partial => 'settings/hide_modules'
  
  name 'Redmine Hide Modules plugin'
  author 'David S Anderson'
  description 'Plugin allowing hiding modules from project settings'
  version '0.0.1'
  url 'https://github.com/ande3577/redmine_hide_modules'
  author_url 'https://github.com/ande3577'
end
