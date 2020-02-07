# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyFeedback' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MyFeedback
  pod 'RxAlamofire'
  pod 'RxCocoa', '~> 5'
  pod "RxSwift", "~> 5.0"
  pod 'ReachabilitySwift'
  pod 'OHHTTPStubs/Swift' # includes the Default subspec, with support for NSURLSession & JSON, and the Swiftier API wrappers
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  
  target 'MyFeedbackTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end
  
  target 'MyFeedbackUITests' do
    # Pods for testing
  end
  
end
