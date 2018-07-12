Pod::Spec.new do |s|
  s.name         = 'AGSAuth'
  s.version      = '1.0.0'
  s.summary      = 'AeroGear Auth Service'

  s.description  = 'AeroGear Auth SDK for iOS'

  s.homepage     = 'http://aerogear.org'
  s.license      = 'Apache License, Version 2.0'
  s.authors      = 'AeroGear'
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source       = { :git => 'https://github.com/aerogear/aerogear-ios-sdk.git',
                     :tag => s.version.to_s}
  s.source_files = 'modules/auth/**/*.swift'
  s.frameworks   = 'UIKit', 'Foundation', 'SystemConfiguration'
  ## Default core dependency
  s.dependency 'AGSCore', s.version.to_s
  ## Add other dependencies if needed
  s.dependency 'AppAuth', '~> 0.93'
  s.dependency 'SwiftKeychainWrapper', '~> 3.0.1'
  s.dependency 'KTVJSONWebToken', '2.0.0'
  s.requires_arc = true
end
