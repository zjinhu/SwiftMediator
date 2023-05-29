
Pod::Spec.new do |s|
  s.name             = 'SwiftMediator'
  s.version          = '1.2.6'
  s.summary          = '路由.'
 
  s.description      = <<-DESC
							工具.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HU' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/SwiftMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = "11.0" 
  s.swift_versions     = ['5.0','5.1','5.2']
  s.requires_arc = true

  s.frameworks   =  "UIKit","Foundation","SwiftUI" #支持的框架

 
  s.subspec 'Protocol' do |ss|
    ss.dependency 'SwiftMediator/Delegate'
    ss.dependency 'SwiftMediator/Tools'
    ss.source_files = 'Sources/SwiftMediator/Protocol/**/*'
  end

  s.subspec 'Target-Action' do |ss|
    ss.dependency 'SwiftMediator/Delegate'
    ss.dependency 'SwiftMediator/Tools'
    ss.source_files = 'Sources/SwiftMediator/Target-Action/**/*'
  end

  s.subspec 'Delegate' do |ss| 
    ss.source_files = 'Sources/SwiftMediator/Delegate/**/*'
  end

  s.subspec 'Tools' do |ss|
    ss.source_files = 'Sources/SwiftMediator/Tools/**/*'
  end
  
  s.default_subspec = 'Target-Action'
end
