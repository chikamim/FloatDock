# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

#作者：Tioks0
#链接：https://juejin.im/post/5ba22293e51d450e46282d68
#来源：掘金
#著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
# 解决xcode10对版本号警告的问题.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['MACOSX_DEPLOYMENT_TARGET'].to_f < 10.15
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.15'
      end
    end
  end
end

# 推荐继续使用 传统的 pod
source 'https://github.com/CocoaPods/Specs.git'
#source 'https://cdn.cocoapods.org/'

target 'FloatDock' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for FloatDock
	
  pod 'Masonry'
  pod 'JSONModel'
  pod 'ReactiveObjC'
  
end
