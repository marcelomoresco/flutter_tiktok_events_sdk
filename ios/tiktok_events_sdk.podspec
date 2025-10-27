
Pod::Spec.new do |s|
  s.name             = 'tiktok_events_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Marcelo Moresco' => 'marcelomoresco0@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Security-related pod configurations
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    # Security: Disable bitcode for enhanced security
    'ENABLE_BITCODE' => 'NO',
    # Security: Enable automatic reference counting for memory safety
    'CLANG_ENABLE_OBJC_ARC' => 'YES',
    # Security: Warning as errors for production builds
    'GCC_TREAT_WARNINGS_AS_ERRORS' => 'NO',
    # Security: Enable stack protector for runtime protection
    'GCC_GENERATE_TEST_COVERAGE_FILES' => 'NO',
    # Security: Minimum deployment target for security updates
    'IPHONEOS_DEPLOYMENT_TARGET' => '11.0'
  }

  s.swift_version = '5.0'
  s.dependency 'TikTokBusinessSDK'
end
