
Pod::Spec.new do |s|
  s.name             = 'SwiftMediator'
  s.version          = '0.0.6'
  s.summary          = '路由.'
 
  s.description      = <<-DESC
							工具.
                       DESC

  s.homepage         = 'https://github.com/jackiehu/' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HU' => '814030966@qq.com' }
  s.source           = { :git => 'https://github.com/jackiehu/SwiftMediator.git', :tag => s.version.to_s }

  s.ios.deployment_target = "11.0" 
  s.swift_version     = '5.1'
  s.requires_arc = true

  s.frameworks   =  "UIKit" #支持的框架

  s.source_files = 'SwiftMediator/SwiftMediator/Class/**/*' 
end
