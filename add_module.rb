#models = Dir.glob("app/models/**/*.rb")
#controllers = Dir.glob("app/controllers/**/*.rb")
#searchers = Dir.glob("app/searchers/**/*.rb")

files = []
#files << models 
#files << controllers 
#files << searchers 

#files << Dir.glob("spec/models/**/*.rb")
#files << Dir.glob("spec/factories/**/*.rb")
files << Dir.glob("spec/controllers/**/*.rb")

files.flatten!

files.delete_if {|f| f.end_with?('application_controller.rb') } 

module_name = ARGV[0]

if module_name.nil?
  p "module_name is needed as the first parameter"
  exit
end

files.each do |file|
  if File.file?(file)
    new_file = File.absolute_path(file) + '.b'
    File.open(new_file, 'w+') do |f|
      f.write("module #{module_name}\n")
      File.readlines(file).each do |l|
        f.write("  #{l}")
      end
      f.write("\nend\n")
    end
    p "#{file} : #{File.basename(file).partition('_').last}"
    File.rename(new_file, "#{File.dirname(file)}/#{File.basename(file).partition('_').last}")
    File.delete(file)
  end
end
