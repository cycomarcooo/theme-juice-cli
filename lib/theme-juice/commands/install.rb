# encoding: UTF-8

module ThemeJuice
    class Command::Install < ::ThemeJuice::Command

        #
        # @param {Hash} opts
        #
        # @return {Void}
        #
        def initialize(opts = {})
            super
            ::ThemeJuice::Service::Config.new.install
        end
    end
end