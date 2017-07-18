# encoding: UTF-8

module ThemeJuice
  module Env
    include SingletonHelper

    attr_accessor :from_path
    attr_accessor :from_srv
    attr_accessor :yolo
    attr_accessor :boring
    attr_accessor :no_unicode
    attr_accessor :no_colors
    attr_accessor :no_animations
    attr_accessor :verbose
    attr_accessor :quiet
    attr_accessor :robot
    attr_accessor :trace
    attr_accessor :dryrun
    attr_accessor :stage
    attr_accessor :cap
    attr_accessor :archive
    attr_accessor :branch

    def from_path=(val)
      @from_path = val || ENV.fetch("TJ_FROM_PATH") { nil }
    end

    def from_srv=(val)
      @from_srv = val || ENV.fetch("TJ_FROM_SRV") { nil }
    end

    def yolo=(val)
      @yolo = val || ENV.fetch("TJ_YOLO") { false }
    end

    def robot=(val)
      @robot = val || ENV.fetch("TJ_ROBOT") { false }
    end

    def boring=(val)
      @boring = val || ENV.fetch("TJ_BORING") { robot || false }
    end

    def no_unicode=(val)
      @no_unicode = val || ENV.fetch("TJ_NO_UNICODE") { boring }
    end

    def no_colors=(val)
      @no_colors = val || ENV.fetch("TJ_NO_COLORS") { boring }
    end

    def no_animations=(val)
      @no_animations = val || ENV.fetch("TJ_NO_ANIMATIONS") { boring }
    end

    def verbose=(val)
      @verbose = val || ENV.fetch("TJ_VERBOSE") { false }
    end

    def quiet=(val)
      @quiet = val || ENV.fetch("TJ_QUIET") { false }
    end

    def trace=(val)
      @trace = val || ENV.fetch("TJ_TRACE") { false }
    end

    def dryrun=(val)
      @dryrun = val || ENV.fetch("TJ_DRYRUN") { false }
    end

    extend self
  end
end
