require "rails_auto_commiter/version"

module RailsAutoCommiter
  @@rails_auto_commiter_sub_commands = []
  @@rails_auto_commiter_commit_files = []
  def self.sub_commands
    @@rails_auto_commiter_sub_commands
  end
  def self.sub_commands=(sub_commands)
    @@rails_auto_commiter_sub_commands = sub_commands
  end
  def self.commit_files
    @@rails_auto_commiter_commit_files
  end
  def self.commit_files=(files)
    @@rails_auto_commiter_commit_files = self.commit_files + files
  end

  module Thor
    module Actions
      module CreateFile
        def invoke_with_conflict_check(&block)
          unless exists? || pretend?
            RailsAutoCommiter.commit_files << destination
          end
          super
        end

        def revoke!
          #RailsAutoCommiter.sub_commands ||= ARGV.dup
          if exists? && !pretend?
            RailsAutoCommiter.commit_files << destination
          end
          super
        end

        protected
          def on_conflict_behavior(&block)
            options = base.options.dup.merge(config)
            if !identical? && pretend?
              RailsAutoCommiter.commit_files << destination
            end
            super
          end

          def force_or_skip_or_conflict(force, skip, &block)
            if force && !pretend?
              RailsAutoCommiter.commit_files << destination
            end
            super
          end
      end
    end
  end

  module Rails
    module CommandsTasks
      def run_command!(command)
        RailsAutoCommiter.sub_commands ||= []
        RailsAutoCommiter.sub_commands << command
        RailsAutoCommiter.sub_commands << ARGV.dup
        super
      end
    end
    module Generators
      module Actions
        module CreateMigration
          def revoke!
            say_destination = exists? ? relative_existing_migration : relative_destination
            if exists? && !pretend?
              RailsAutoCommiter.commit_files << say_destination
            end
            super
          end

          protected
            def on_conflict_behavior
              options = base.options.dup.merge(config)
              if !identical? && options[:force] && !pretend?
                RailsAutoCommiter.commit_files << existing_migration
              end
              super
            end
        end
      end
    end
  end
end


Thor::Actions::CreateFile.send(:prepend, RailsAutoCommiter::Thor::Actions::CreateFile)
Rails::Generators::Actions::CreateMigration.send(:prepend, RailsAutoCommiter::Rails::Generators::Actions::CreateMigration)
Rails::CommandsTasks.send(:prepend, RailsAutoCommiter::Rails::CommandsTasks)
at_exit do
  if RailsAutoCommiter.commit_files.any?
    sub_commands = RailsAutoCommiter.sub_commands.join(' ')
    commit_files = RailsAutoCommiter.commit_files.join(" ")
    system("git add #{commit_files}")
    system("git commit -o #{commit_files} -m \"result of 'rails #{sub_commands}'.\"")
  end
end
