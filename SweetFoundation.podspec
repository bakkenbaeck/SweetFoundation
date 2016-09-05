Pod::Spec.new do |s|
  s.name             = "SweetFoundation"
  s.summary          = "A short description of SweetFoundation."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/bakkenbaeck/SweetFoundation"
  s.license          = 'MIT'
  s.author           = { "Bakken & Bæck" => "post@bakkenbaeck.no" }
  s.source           = { :git => "https://github.com/bakkenbaeck/SweetFoundation.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bakkenbaeck'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end