Pod::Spec.new do |s|
  s.name             = "AMPSYFAdapter"
  s.version          = "6.1.1.1"
  s.summary          = "AMPSYFAdapter for Beizi"
  s.description      = <<-DESC
  WMYFAdAdapter 提供YF广告适配支持。
  DESC

  s.homepage         = "https://your-homepage.example"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Erik" => "your-email@example.com" }

  # 你的源码位置（通常放在 Git）
  s.source           = { :git => "https://github.com/com-yifan/ios-beizi-yf-adapter.git", :tag => s.version }

  # ⚠️ Podspec 要求 xcframework 必须放在下面结构：
  # WMYFAdAdapter/
  # ├── WMYFAdAdapter.xcframework
  s.vendored_frameworks = "AMPSYFAdapter/AMPSYFAdapter.xcframework"

  # 平台
  s.platform     = :ios, "11.0"

  s.static_framework = true
end
