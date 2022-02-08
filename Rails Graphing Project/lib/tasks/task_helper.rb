module ResultsGraphingFhir
  module TaskHelper
    # Returns the root folder
    def root_dir
      Rails.root.join('.')
    end

    # Executes a string or an array of strings in a shell in the given directory
    def sh_in_dir(dir, shell_commands)
      success = true
      shell_commands = [shell_commands] if shell_commands.is_a?(String)
      shell_commands.each do |shell_command|
        sh %(cd #{dir} && #{shell_command.strip}) do |ok|
          success = false unless ok
        end
      end
      success
    end
  end
end
