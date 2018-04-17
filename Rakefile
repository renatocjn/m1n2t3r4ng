# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

namespace :services do
    desc "Reset stabilization timers"
    task :reset_stabilization_timers => :environment do
        MonitoredService.update_all new_status_time: nil
    end
end

namespace :crono do
    desc "Start crono daemon on production environment"
    task :start_prod do
        `RAILS_ENV=production bundle exec crono start`
    end
    
    desc "Start crono daemon on development environment"
    task :start_dev do
        `RAILS_ENV=development bundle exec crono start`
    end
    
    desc "Stop crono daemon"
    task :stop do
        `bundle exec crono stop`
    end
    
    desc "Stop crono daemon"
    task :restart do
        `bundle exec crono restart`
    end
end

namespace :logs do
    desc "Delete all monitoring logs"
    task :delete_all => :environment do
        MonitoredServiceLog.delete_all
    end
    
    desc "Delete all monitoring logs but the ones created within 24h"
    task :delete_day_old => :environment do
        MonitoredServiceLog.where("created_at <= ?", 1.day.ago).delete_all
    end
    
    desc "Delete all monitoring logs but the ones created within the week"
    task :delete_week_old => :environment do
        MonitoredServiceLog.where("created_at <= ?", 1.week.ago).delete_all
    end
end

Rails.application.load_tasks
