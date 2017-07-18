describe ThemeJuice::Tasks::Load do

  before do
    @env = ThemeJuice::Env
    @project = ThemeJuice::Project

    allow(@env).to receive(:verbose).and_return true
    allow(@env).to receive(:dryrun).and_return true

  end

  before :each do
    @task = ThemeJuice::Tasks::Load.new
    @config = ThemeJuice::Config
    allow_any_instance_of(@config).to receive(:deployment)
      .and_return YAML.load %Q{
stages:
  production:
    server: 192.168.50.4
    path: /var/www/production
    user: deploy
    url: example.com
    uploads: app/uploads
    tmp: tmp
    shared:
      - .htaccess
      - .env
      - shared/dir/
    ignore:
      - robots.txt
    roles:
      - :web
      - :app
      - :db
}
  end

  describe "#execute" do

    context "when Slack key is present in the config" do

      before do
        allow_any_instance_of(@config).to receive(:deployment)
          .and_return YAML.load %Q{
slack:
  url: https://hooks.slack.com/services/some-token
  username: Deploybot
  channel: "#devops"
  emoji: ":rocket:"
    }
      end

      it "should load Capistrano with Slack integration" do
        allow(@task).to receive :load_tasks
        allow(@task).to receive :load_custom_tasks

        allow(stdout).to receive :print

        expect(@task).to receive(:require).with "capistrano/setup"
        expect(@task).to receive(:require).with "capistrano/deploy"
        expect(@task).to receive(:require).with "capistrano/rsync"
        expect(@task).to receive(:require).with "capistrano/slackify"
        expect(@task).to receive(:require).with "capistrano/framework"

        expect { @task.execute }.to_not raise_error
      end
    end

    context "when Slack key is not present in the config" do
      it "should load Capistrano without Slack integration" do
        allow(@task).to receive :load_tasks
        allow(@task).to receive :load_custom_tasks

        allow(stdout).to receive :print

        expect(@task).to receive(:require).with "capistrano/setup"
        expect(@task).to receive(:require).with "capistrano/deploy"
        expect(@task).to receive(:require).with "capistrano/rsync"
        expect(@task).to_not receive(:require).with "capistrano/slackify"
        expect(@task).to receive(:require).with "capistrano/framework"

        expect { @task.execute }.to_not raise_error
      end
    end

    it "should load Capistrano tasks" do
      allow(@task).to receive :load_capistrano
      allow(@task).to receive :load_custom_tasks

      allow(stdout).to receive :print

      expect(@task).to receive(:load).with(/tasks\/capistrano/)
        .at_least :once

      expect { @task.execute }.to_not raise_error
    end
  end
end
