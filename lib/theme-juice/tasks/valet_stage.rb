# encoding: UTF-8

module ThemeJuice
  module Tasks
    class VALETStage < Task
      include Capistrano::DSL

      def initialize
        super

        @valet = @config.deployment.stages.valet
      end

      def execute
        configure_val_stage
      end

      private

      def configure_val_stage
        @io.log "Configuring Valet stage"

        server @valet.server, {
          # :user       => @valet.user,
          # :password   => @valet.pass,
          :roles      => @valet.roles,
          :no_release => true
        }

        set :val_path,       -> { @valet.path }
        set :val_url,         -> { @valet.url }
        set :val_uploads_dir, -> { @valet.uploads }
        set :val_backup_dir,  -> { @valet.backup }
        set :val_tmp_dir,     -> { @valet.tmp }
      end
    end
  end
end
