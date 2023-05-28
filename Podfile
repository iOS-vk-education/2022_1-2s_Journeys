# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Journeys' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Journeys
  pod 'SnapKit', '5.6.0'
  pod 'SwiftLint'
  pod 'SwiftGen', '~> 6.5.1'
  pod 'PureLayout'
  pod 'YandexMapsMobile', '4.2.2-full'
  pod 'FSCalendar'
  
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseAnalytics'
  pod 'FirebaseStorage'

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

end
