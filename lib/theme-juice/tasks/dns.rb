# encoding: UTF-8

module ThemeJuice
  module Tasks
    class DNS < Entry

      def initialize(opts = {})
        super

        @entry_file = "#{@env.vm_path}/Customfile"
        @entry_name = "DNS"
        @entry_id   = "DNS"
      end

      def execute
        create_entry_file
        create_entry do
%Q{
if defined? VagrantPlugins::Landrush
  config.landrush.host '#{@project.url}', '#{@env.vm_ip}'
elsif defined? VagrantPlugins::HostsUpdater
  config.hostsupdater.aliases << '#{@project.url}'
end
}
        end
      end

      def unexecute
        remove_landrush_entry
        remove_entry
      end

      private

      def remove_landrush_entry
        unless @env.no_landrush
          @util.run "vagrant landrush rm #{@project.url}",
            :verbose => @env.verbose
        end
      end
    end
  end
end
