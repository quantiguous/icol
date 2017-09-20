folders = Dir.glob("app/views/**/*")

module_name = ARGV[0]

if module_name.nil?
  p "module_name is needed as the first parameter"
  exit
end

module_name = module_name.downcase

folders.each do |folder|
  if File.directory?(folder)
    if folder.include?("#{module_name}_")
      File.rename(folder, "#{File.dirname(folder)}/#{File.basename(folder).partition("#{module_name}_").last}")
    end
  end
end

File.delete("app/views/layouts/#{module_name}/application.html.erb") rescue "file not present"
