
Pod::Spec.new do |s|
  s.name         = "JXExcel"
  s.version = "0.0.1"
  s.summary      = "一个轻量级的表视图"
  s.homepage     = "https://github.com/pujiaxin33/JXExcel"
  s.license      = "MIT"
  s.author       = { "pujiaxin33" => "317437084@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version = "5.0"
  s.source       = { :git => "https://github.com/pujiaxin33/JXExcel.git", :tag => "#{s.version}" }
  s.framework    = "UIKit"
  s.source_files  = "Sources", "Sources/*.{swift}"
  s.resource = 'Resources/Resource.bundle'
  s.requires_arc = true
 
end
