# encoding: UTF-8

namespace :db do

  desc "Initialize database variables"
  task :init do
    set :timestamp, Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    set :remote_db, "#{fetch(:timestamp)}.#{fetch(:stage)}.sql"
    set :local_db, "#{fetch(:timestamp)}.local.sql"
  end

  desc "Backup database on remote to local"
  task :backup do
    set :timestamp_backup, Time.now.strftime("%Y-%m-%d-%H-%M-%S")
    set :remote_db_backup, "#{fetch(:timestamp_backup)}.#{fetch(:stage)}.backup.sql"

    on release_roles(:db) do

      within release_path do
        execute :mkdir, "-p", fetch(:tmp_dir)
        execute :wp, :db, :export, "#{fetch(:tmp_dir)}/#{fetch(:remote_db_backup)}", "--add-drop-table"
      end

      run_locally do
        execute :mkdir, "-p", fetch(:val_backup_dir)
      end

      download! release_path.join("#{fetch(:tmp_dir)}/#{fetch(:remote_db_backup)}"),
        "#{fetch(:val_backup_dir)}/#{fetch(:remote_db_backup)}"

      within release_path do
        execute :rm, "#{fetch(:tmp_dir)}/#{fetch(:remote_db_backup)}"
      end
    end
  end

  desc "Push local database to remote"
  task :push do
    invoke "db:backup"
    invoke "db:init"

    run_locally do
      execute :wp, :db, :export, "#{fetch(:val_backup_dir)}/#{fetch(:local_db)}"
    end

    on release_roles(:db) do
      upload! "#{fetch(:val_backup_dir)}/#{fetch(:local_db)}", release_path
        .join("#{fetch(:tmp_dir)}/#{fetch(:local_db)}")

      within release_path do
        execute :wp, :db, :import, "#{fetch(:tmp_dir)}/#{fetch(:local_db)}"
        execute :rm, "#{fetch(:tmp_dir)}/#{fetch(:local_db)}"
        execute :wp, "search-replace", fetch(:val_url), fetch(:stage_url), fetch(:wpcli_args) || "--skip-columns=guid --all-tables"
      end
    end


    run_locally do
      execute :rm, "#{fetch(:val_backup_dir)}/#{fetch(:local_db)}"

    end
  end

  desc "Pull remote database to local"
  task :pull do
    invoke "db:backup"
    invoke "db:init"

    on release_roles(:db) do
      within release_path do
        execute :wp, :db, :export, "#{fetch(:tmp_dir)}/#{fetch(:remote_db)}"
        download! release_path.join("#{fetch(:tmp_dir)}/#{fetch(:remote_db)}"),
          "#{fetch(:val_backup_dir)}/#{fetch(:remote_db)}"
        execute :rm, "#{fetch(:tmp_dir)}/#{fetch(:remote_db)}"
      end
    end

    run_locally do
      execute :wp, :db, :import, "#{fetch(:val_backup_dir)}/#{fetch(:remote_db)}"
      execute :rm, "#{fetch(:val_backup_dir)}/#{fetch(:remote_db)}"
      execute :wp, "search-replace", fetch(:stage_url), fetch(:val_url), fetch(:wpcli_args) || "--skip-columns=guid --all-tables"
    end
  end
end
