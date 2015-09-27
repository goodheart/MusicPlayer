#
#  Be sure to run `pod spec lint MusicPlayer.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "MusicPlayer"
  s.version      = "0.0.1"
  s.summary      = "一个在线音乐播放器"
  s.homepage     = "https://github.com/goodheart/MusicPlayer"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "goodheart" => "1075623679@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = {:git => "https://github.com/goodheart/MusicPlayer.git" }
  s.source_files  =  "MusicPlayer/MusicPlayer/"
  s.framework  = "AVFoundation"
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/MusicPlayer/" }
end
