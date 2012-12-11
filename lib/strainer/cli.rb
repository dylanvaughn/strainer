require 'strainer'

module Strainer
  # Use our own custom shell
  Thor::Base.shell = Strainer::UI

  # Cli runner for Strainer
  #
  # @author Seth Vargo <sethvargo@gmail.com>
  class Cli < Thor
    # global options
    map ['-v', '--version'] => :version
    class_option :cookbooks_path, :type => :string,  :aliases => '-p', :desc => 'The path to the cookbook store', :banner => 'PATH'
    class_option :config,         :type => :string,  :aliases => '-c', :desc => 'The path to the knife.rb config'

    # strainer test *COOKBOOKS
    method_option :except,        :type => :array,   :aliases => '-e', :desc => 'Strainerfile labels to ignore'
    method_option :only,          :type => :array,   :aliases => '-o', :desc => 'Strainerfile labels to include'
    method_option :fail_fast,     :type => :boolean, :aliases => '-x', :desc => 'Stop termination immediately if a test fails', :banner => '', :default => false
    desc 'test [COOKBOOKS]', 'Run tests against the given cookbooks'
    def test(*cookbooks)
      Strainer::Runner.new(cookbooks, options)
    end

    # strainer info
    desc 'info', 'Display version and copyright information'
    def info
      Strainer.ui.info "Strainer (#{Strainer::VERSION})"
      Strainer.ui.info "\n"
      Strainer.ui.info File.read Strainer.root.join('LICENSE')
    end

    # strainer -v
    desc 'version', 'Display the version information', hide: true
    def version
      Strainer.ui.info Strainer::VERSION
    end
  end
end
