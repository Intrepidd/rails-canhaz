module CanHaz
	module Generators
		class InstallGenerator < Rails::Generators::Base
			desc "Generats the default migrations for rails-canhaz"
			
			include Rails::Generators::Migration
			
			def self.source_root
				@_can_haz_source_root ||= File.expand_path("../templates", __FILE__)
			end
			
			def self.next_migration_number(dirname)
				Time.now.strftime("%Y%m%d%H%M%S")
			end
			
			def create_migrations
				Dir["#{self.class.source_root}/migrations/*.rb"].sort.each do |filepath|
					name = File.basename(filepath)
					migration_template "migrations/#{name}", "db/migrate/#{name.gsub(/^\d+_/,'')}"
					sleep 1
				end
			end 

		end
	end
end