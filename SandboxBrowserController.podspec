
Pod::Spec.new do |s|
  s.name             = 'SandboxBrowserController'
  s.version          = '1.0.0'
  s.summary          = '沙盒文件浏览器'
  
  s.homepage         = 'https://github.com/Weang/SandboxBrowserController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'w704444178@qq.com' => 'w704444178@qq.com' }
  s.source           = { :git => 'https://github.com/Weang/SandboxBrowserController.git', :tag => s.version.to_s }
  
  s.ios.deployment_target  = '10.0'
  
  s.source_files = 'SandboxBrowserController/Classes/**/*'
  s.resources = 'SandboxBrowserController/Assets/*'
  s.swift_versions = "5.0"
  s.dependency 'SnapKit', '~> 5.0.0'
end
