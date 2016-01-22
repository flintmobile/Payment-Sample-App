source 'https://github.com/flintmobile/ios-flint-connect-sdk.git' 
platform :ios, '8.0'
use_frameworks!

pod 'FlintConnectSDK'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
