# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'Alamofire'
  pod 'Kingfisher', '~> 7.0'
  
end

target 'WBPO' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WBPO
  shared_pods

  target 'WBPOTests' do
    inherit! :search_paths
    # Pods for testing
    shared_pods
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'

  end

  target 'WBPOUITests' do
    # Pods for testing
    shared_pods
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'

  end

end
