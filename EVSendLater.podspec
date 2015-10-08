Pod::Spec.new do |s|
  s.name             = "EVSendLater"
  s.version          = "0.2.0"
  s.summary          = "Easy offline HTTP request handling with Swift"
  s.homepage         = "https://github.com/enzosv/EVSendLater"
  s.license          = 'MIT'
  s.author           = { "Enzo Vergara" => "vergara.enzo@gmail.com" }
  s.source           = { :git => "https://github.com/enzosv/EVSendLater.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/enzosv'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
