Pod::Spec.new do |s|
  s.name         = 'AGSSync'
  s.version      = '2.0.0'
  s.summary      = 'AeroGear Services Sync'

  s.description  = 'AeroGear Services Data Sync SDK'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version}
  s.source_files = 'modules/sync/**/*.swift'
  s.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
  ## Default core dependency
  s.dependency 'AGSCore'
  s.dependency 'Apollo'
  s.requires_arc = true
end
