Pod::Spec.new do |s|
  s.name             = "SweetFoundation"
  s.summary          = "Helpers and sugar for the Foundation framework"
  s.version          = "1.3.0"
  s.homepage         = "https://github.com/UseSweet/SweetFoundation"
  s.license          = 'MIT'
  s.author           = { "Bakken & Bæck" => "ios@bakkenbaeck.no" }
  s.source           = { :git => "https://github.com/UseSweet/SweetFoundation.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BakkenBaeck'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end
