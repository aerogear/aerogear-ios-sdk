## Ruby script that allows local development without Xcode and even mac.
## Script will add and append all new files to Xcode project
## After that changes can be build using CircleCi 

## Based on https://github.com/CocoaPods/Xcodeproj/issues/178

require 'xcodeproj'

def addfiles (direc, current_group, main_target)
    Dir.glob(direc) do |item|
        next if item == '.' or item == '.DS_Store'

                if File.directory?(item)
            new_folder = File.basename(item)
            created_group = current_group.new_group(new_folder)
            addfiles("#{item}/*", created_group, main_target)
        else 
          i = current_group.new_file(item)
          if item.include? ".swift"
              main_target.add_file_references([i])
          end
        end
    end
end

project_path = './example/AeroGearSdkExample.xcodeproj'
project = Xcodeproj::Project.open(project_path)

default_group = project.new_group('default')

mainPath = './example'
main_target = project.targets.first

addfiles("#{mainPath}/*", default_group, main_target)

project.save(project_path)