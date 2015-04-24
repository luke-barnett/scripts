#!/usr/bin/env ruby
require "fileutils"

if !ENV["WallpapersDirectory"]
  ENV["WallpapersDirectory"] = "#{Dir.home}/Dropbox/IFTTT/reddit/wallpapers"
end

wallpapers = Dir["#{ENV["WallpapersDirectory"]}/*"]
currentTime = Time.now

wallpapers.each do |wallpaper|
  if File.size(wallpaper) < 1000000
    FileUtils.rm(wallpaper)
    next
  end
  timespan = currentTime - File.mtime(wallpaper)

  if timespan > 2592000 #30 days in seconds
    FileUtils.rm(wallpaper)
    next
  end

  #TODO check image dimensions want at least 1080p
end
