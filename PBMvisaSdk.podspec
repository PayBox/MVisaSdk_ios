
Pod::Spec.new do |s|

 

  s.name         = "PBMvisaSdk"
  s.version      = "0.9.3"
  s.summary      = "PBMvisaSdk"
  s.description  = "mvisaSdk"
  s.homepage     = "http://paybox.money"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.pod_target_xcconfig = {'SWIFT_VERSION' => '4.0','LIBRARY_SEARCH_PATHS' => '$(SRCROOT)/PBMvisaSdk/'}
  s.author             = { "Arman" => "am@paybox.money" }
  s.dependency 'PayBoxSdk'
  s.public_header_files = 'PBMvisaSdk/*.h'
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/PayBox/PBMvisaSdk.git", :tag => "#{s.version}",
                        :git => "https://github.com/PayBox/SDK_iOS-input-.git", :tag => "1.0.7" }
  s.source_files  = 'PBMvisaSdk/*.{swift,h}', 'PBMvisaSdk/commonCrypto/*.{c,h}'
  s.libraries = 'z'
  
end
