# Theme Juice [![Gem Version](https://badge.fury.io/rb/theme-juice.svg)](http://badge.fury.io/rb/theme-juice)
Command line interface to scaffold out a new WordPress development environment and countless sites. Everybody loves one command setups, and `tj` even does one command deployments too.

## Installation
* First, install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) for local development.
* Then, install [Composer](https://getcomposer.org/) and [WP-CLI](http://wp-cli.org/) (make sure they're executable).
* Finally, install with: `gem install theme-juice`

That`s it!

## Usage

#### List available commands:
List all commands for `tj`.
```bash
tj
```

#### Print version:
This command will print the current version of `tj`.
```bash
tj version
```

#### Setup VVV:
This command will _only_ setup [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV). It will not prompt you to create a new site. _Note: This is automatically run when you create your first site._
```bash
tj init
```

#### Creating a new development site:
Use this to create a new development site. It will automagically set up your entire development environment, including a local development site at `http://<sites-dev-url>.dev` with WordPress installed and a fresh WP database. It will sync up your local site installation with the Vagrant VM. This task will also install and configure Vagrant/VVV into your `~/` directory if it has not already been installed. Site name is optional, as it will be asked for if not given.
```bash
tj create [<SITE-NAME>]
```

#### Setting up an existing site:
Use this to setup an existing local site installation within the development environment. You will go through the setup process to create the necessary files for the VM, including `vvv-hosts`, `vvv-nginx.conf`, and a fresh database (unless one already exists by the name chosen). Site name is optional, as it will be asked for if not given.
```bash
tj setup [<SITE-NAME>] # Alias for 'tj create [<SITE-NAME>] --bare'
```

#### Deleting a site from the VM: _(Does not remove your local site)_
Use this to remove a site from your development environment. This is only remove files that were generated by `tj`. including the database setup, development url, and shared directories. _It will not touch your local files._
```bash
tj delete <SITE-NAME>
```

#### Listing all `tj` sites in the VM:
Use this to list all sites within your development environment that were generated by `tj`.
```bash
tj list
```

#### Watching and compiling assets: _(Guard)_
Use this to watch and compile assets with [Guard](https://github.com/guard/guard). This is simply a wrapper for Guard commands.
```bash
tj watch # Alias for 'bundle exec guard [COMMANDS]'
```

#### Managing development environment: _(Vagrant)_
Use this to easily manage your [Varying Vagrant Vagrants](https://github.com/Varying-Vagrant-Vagrants/VVV) development environment. This is simply a wrapper for Vagrant commands.
```bash
tj vm # Alias for 'cd ~/vagrant && vagrant [COMMANDS]'
```

#### Managing vendor dependencies: _(Composer)_
Use this to easily manage your [Composer](https://github.com/composer/composer) dependencies. This is simply a wrapper for Composer commands.
```bash
tj vendor # Alias for 'composer [COMMANDS]'
```

#### Managing deployment and migration: _(Capistrano)_
Use this to easily manage your deployment and migration with [Capistrano](https://github.com/capistrano/capistrano). This is simply a wrapper for Capistrano commands.
```bash
tj server # Alias for 'bundle exec cap [COMMANDS]'
```

#### Executing WP-CLI locally inside your VM with `wp-cli-ssh`
You can run `wp` commands locally if you specify a `--host`. Upon setup, an `ssh` block for the VM is automatically added to the `wp-cli.local.yml` file with all of your development environment paths.
```bash
wp ssh --host=vagrant [COMMANDS]

# Create an alias
alias wpv="wp ssh --host=vagrant"
```

## Contributing

1. First, create an [issue](https://github.com/ezekg/theme-juice-cli/issues) for your proposed feature. If it's a bug fix, go right to step 2.
2. [Fork the repository](https://github.com/ezekg/theme-juice-cli/fork).
3. Create a new feature branch. (`git checkout -b my-new-feature`)
4. Commit your changes. (`git commit -am `Add some feature``)
5. Push to the new branch. (`git push origin my-new-feature`)
6. Create a new Pull Request.
