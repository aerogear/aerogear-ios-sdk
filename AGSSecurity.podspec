Pod::Spec.new do |s|
  s.name         = 'AGSSecurity'
  s.version      = '0.3.1'
  s.summary      = 'OWASP Security Checks'

  s.description  = 'AeroGear Services security'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version.to_s}
  s.source_files = 'modules/security/**/*.swift'
  s.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
  s.dependency 'AGSCore'
  s.dependency 'DTTJailbreakDetection'
  s.requires_arc = true

end
