require 'rake'

desc 'Run tests'
task :test do
  Dir.glob('**/*_test.rb').each do |test_file|
    command = "ruby -Itest -Ilib #{test_file}"
    system(command)
    color = $?.success? ? "\e[32m" : "\e[31m"
    puts("#{color}#{test_file}\e[0m")
  end
end

task :default => :test