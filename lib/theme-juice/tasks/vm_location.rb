# encoding: UTF-8

module ThemeJuice
  module Tasks
    class VMLocation < Task

      def initialize(opts = {})
        super
      end

      def execute
        create_path
      end

      def unexecute
        remove_path
      end

      private

      def create_path
        @interact.log "Creating project location in VM"
        @util.empty_directory @project.vm_location, :verbose => @env.verbose
      end

      def remove_path
        @interact.log "Removing project location in VM"
        @util.remove_dir @project.vm_location, :verbose => @env.verbose
      end
    end
  end
end