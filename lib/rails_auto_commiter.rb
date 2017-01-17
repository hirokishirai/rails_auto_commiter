require "rails_auto_commiter/version"
require 'rails/commands/commands_tasks'

module RailsAutoCommiter
  @@rails_auto_commiter_sub_commands = []
  @@git_stashed = false

  def self.git_stashed?
    @@git_stashed
  end

  def self.git_stashed=(bool)
    @@git_stashed = bool
  end

  def self.sub_commands
    @@rails_auto_commiter_sub_commands
  end
  def self.sub_commands=(sub_commands)
    @@rails_auto_commiter_sub_commands = sub_commands
  end

  module Rails
    module CommandsTasks
      def run_command!(command)
        #RailsAutoCommiter.sub_commands ||= []
        RailsAutoCommiter.sub_commands << command
        RailsAutoCommiter.sub_commands << ARGV.dup
        unless `git status`.match(/nothing to commit, working directory clean/)
          system('git stash')
          RailsAutoCommiter.git_stashed = true
        end
        super
      end
    end
  end
end
Rails::CommandsTasks.send(:prepend, RailsAutoCommiter::Rails::CommandsTasks)

at_exit do
  unless `git status`.match(/nothing to commit, working directory clean/)
    system('git add .')
    sub_commands = RailsAutoCommiter.sub_commands.join(' ')
    system("git commit -m \"result of 'rails #{sub_commands}'.\"")
  end
  if RailsAutoCommiter.git_stashed?
    system('git stash pop')
  end
end
