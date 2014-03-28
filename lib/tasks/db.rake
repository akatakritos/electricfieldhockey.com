namespace :db do
  desc 'loads the production db down to development'
  task :load_production => :environment do

    config = YAML.load_file File.join("config", "tasks_config.yml")
    user = config["servers"]["production"]["user"]
    host = config["servers"]["production"]["host"]
    root_path = config["servers"]["production"]["root_path"]

    db_file = File.join("db", Rails.env + ".sqlite3")
    puts "Backing up database: #{db_file}"
    FileUtils.cp db_file, "#{db_file}.bak"

    puts "dumping production..."
    system %Q{ ssh #{user}@#{host} 'bash -l -c "cd #{root_path}; rake db:dump"' }

    puts "downloading dump file..."
    system %Q{ scp #{user}@#{host}:#{File.join(root_path,'db','data.yml')} ./db/ }


    puts "importing dump file..."
    Rake::Task["db:load"].invoke

    puts "downloading background images..."
    system %Q{ scp -r #{user}@#{host}:#{File.join(root_path,'public','uploads','*')} #{File.join('public','uploads','/')} }

    puts "done!"
    
  end
end
