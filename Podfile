platform :ios, '10.0'

target 'persistance' do

  use_frameworks!
  pod 'RealmSwift'

end

post_install do |installer|
     installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
                 config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
           end
     end
end
