Pod::Spec.new do |s|
  s.name         = "AOIntroRunner"
  s.version      = “0.0.1”
  s.summary      = “Show Intro”
  s.description  = “Show intro screen anywhere”
  s.homepage     = "https://github.com/alekoleg/AOIntroRunner.git"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/AOIntroRunner.git", :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'
  s.public_header_files = 'Classes/*.h'
  s.frameworks = 'Foundation', 'UIKit', 'QuartzCore', 'CoreGraphics'
  
end
