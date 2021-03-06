#!/usr/bin/env ruby
require "fileutils"
require "fastimage"

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

  width, height = FastImage.size(wallpaper)

  if width < 1920 or height < 1080
    FileUtils.rm(wallpaper)
    next
  end
end
