# encoding: UTF-8

module ThemeJuice
  class CLI < Thor

    def initialize(*)
      super

      @version = VERSION
      @env     = Env
      @io      = IO
      @config  = Config
      @project = Project
      @util    = Util.new
      @list    = Tasks::List
      @create  = Commands::Create
      @deploy  = Commands::Deploy

      init_env
    end

    no_commands do
      def init_env
        @env.from_path       = options[:from_path]
        @env.from_srv        = options[:from_srv]
        @env.yolo            = options[:yolo]
        @env.boring          = options[:boring]
        @env.no_unicode      = options[:no_unicode]
        @env.no_colors       = options[:no_colors]
        @env.no_animations   = options[:no_animations]
        @env.verbose         = options[:verbose]
        @env.quiet           = options[:quiet]
        @env.robot           = options[:robot]
        @env.trace           = options[:trace]
        @env.dryrun          = options[:dryrun]
        @env.archive         = options[:archive]
        @env.branch          = options[:branch]
      end
    end

    map %w[man doc docs]           => :help
    map %w[--version -v]           => :version
    map %w[--env]                  => :env
    map %w[mk new]                 => :create
    map %w[server remote]          => :deploy

    class_option :from_path,       :type => :string,  :aliases => "--in-path", :default => nil, :desc => ""
    class_option :from_srv,        :type => :string,  :aliases => "--in-srv",  :default => nil, :desc => ""
    class_option :yolo,            :type => :boolean, :aliases => "--yes",                      :desc => ""
    class_option :boring,          :type => :boolean,                                           :desc => ""
    class_option :no_unicode,      :type => :boolean,                                           :desc => ""
    class_option :no_colors,       :type => :boolean, :aliases => "--no-color",                 :desc => ""
    class_option :no_animations,   :type => :boolean,                                           :desc => ""
    class_option :verbose,         :type => :boolean,                                           :desc => ""
    class_option :quiet,           :type => :boolean, :aliases => "--shh",                      :desc => ""
    class_option :robot,           :type => :boolean,                                           :desc => ""
    class_option :trace,           :type => :boolean,                                           :desc => ""
    class_option :dryrun,          :type => :boolean, :aliases => "--dry-run",                  :desc => ""

    desc "--help, -h", "View man page"
    def help(command = nil)
      root = File.expand_path "../man", __FILE__
      man = ["tj", command].compact.join("-")
      begin
        man_path = "#{root}/#{man}"
        if File.exist? man_path
          shell_escaped_man_path = man_path.shellescape
          if OS.windows?
            @io.say File.read("#{shell_escaped_man_path}.txt"), :color => :white
          else
            @util.run "man #{shell_escaped_man_path}", :verbose => @env.verbose
          end
        else
          @io.say "No man page available for '#{command}'", :color => :red
        end
      rescue
        super
      end
    end

    desc "--version, -v", "Print current version"
    def version
      @io.say @version, :color => :green
    end

    desc "--env [PROP]", "Print an environment property"
    method_option :property, :type => :string, :aliases => %w[-p --prop], :default => nil, :desc => ""
    def env
      if options[:property].nil?
        @io.list "Environment:", :green, @env.inspect
      else
        prop = options[:property].gsub "-", "_"

        @io.error "Environment property '#{prop}' does not exist",
        NotImplementedError unless @env.respond_to? prop

        @io.say @env.send(prop), :color => :green
      end
    end

    desc "create", "Create new project"
    method_option :name,              :type => :string,  :aliases => "-n",                  :default => nil,  :desc => ""
    method_option :location,          :type => :string,  :aliases => "-l",                  :default => nil,  :desc => ""
    method_option :template,          :type => :string,  :aliases => "-t",                  :default => nil,  :desc => ""
    method_option :template_revision, :type => :string,  :aliases => %w[--template-branch], :default => nil,  :desc => ""
    method_option :url,               :type => :string,  :aliases => "-u",                  :default => nil,  :desc => ""
    method_option :repository,        :type => :string,  :aliases => "-r",                                    :desc => ""
    method_option :bare,              :type => :boolean, :aliases => %w[--no-template],                       :desc => ""
    method_option :skip_repo,         :type => :boolean,                                                      :desc => ""
    method_option :use_defaults,      :type => :boolean,                                                      :desc => ""
    method_option :no_wp,             :type => :boolean,                                                      :desc => ""
    method_option :no_wp_cli,         :type => :boolean, :aliases => %w[--no-wp-cli-config],                  :desc => ""
    method_option :no_env,            :type => :boolean,                                                      :desc => ""
    method_option :no_config,         :type => :boolean, :aliases => %w[--no-juicefile],                      :desc => ""
    method_option :wp_config_modify,  :type => :boolean, :aliases => %w[--modify-wp-config],                  :desc => ""
    def create
      @io.hello
      @create.new(options).execute
    end

    desc "deploy STAGE [,ARGS]", "Deploy a project"
    method_option :archive, :type => :boolean, :aliases => %w[--tar --gzip --zip], :desc => ""
    method_option :branch,  :type => :string,  :aliases => "-b", :default => nil,  :desc => ""
    def deploy(stage, *args)
      @deploy.new(options).send(stage, *args).execute
    end

    # For dynamic methods defined within the config
    def method_missing(method, *args, &block)

      # Force Thor to parse options
      parser   = Thor::Options.new self.class.class_options
      @options = parser.parse args

      # Init env (again) with parsed options
      init_env

      err = -> { @io.error "Could not find command '#{method}'" }
      err.call unless @config.exist?

      if @config.commands.has_key? "#{method}"
        @config.command method.to_sym, args
      else
        err.call
      end
    end
  end
end
