# encoding: UTF-8

module ThemeJuice
  module Project
    include SingletonHelper

    attr_accessor :name
    attr_accessor :location
    attr_accessor :url
    attr_accessor :template
    attr_accessor :template_revision
    attr_accessor :repository
    attr_accessor :db_host
    attr_accessor :db_name
    attr_accessor :db_user
    attr_accessor :db_pass
    attr_accessor :db_import
    attr_accessor :db_drop
    attr_accessor :bare
    attr_accessor :skip_repo
    attr_accessor :skip_db
    attr_accessor :use_defaults
    attr_accessor :no_wp
    attr_accessor :no_wp_cli
    attr_accessor :no_db
    attr_accessor :no_env
    attr_accessor :no_ssl
    attr_accessor :no_config
    attr_accessor :wp_config_modify

    extend self
  end
end
