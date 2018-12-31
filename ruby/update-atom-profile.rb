#!/usr/bin/env ruby
require "fileutils"

if !ENV["atomProfileRepo"]
  ENV["atomProfileRepo"] = "https://luke-barnett@bitbucket.org/luke-barnett/atom-profile.git"
end

currentWorkingDirectory = Dir.pwd
atomProfileDirectory = "#{Dir.home}/.atom"

if File.directory?("#{atomProfileDirectory}/.git")
  puts "Atom profile exists resetting to origin/master"
  Dir.chdir atomProfileDirectory
  system("git clean -xdf")
  system("git fetch origin")
  system("git reset --hard origin/master")
else
  if File.directory(atomProfileDirectory)
    puts "Removing non git profile"
    FileUtils.rm_rf(atomProfileDirectory)
  else
    puts "Cloning atom profile"
    system("git clone #{ENV["atomProfileRepo"]} #{atomProfileDirectory}")
  end
end

(Dir.glob("#{atomProfileDirectory}/packages/*").select {|f| File.directory? f}).each do |directory|
  Dir.chdir directory
  system ("npm install")
end

Dir.chdir currentWorkingDirectory
