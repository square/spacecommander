# coding: utf-8
Pod::Spec.new do |s|
  s.name         = "SpaceCommander"
  s.version      = "1.1.7"
  s.summary      = "[ SpaceCommander] provides tools which enable you to commit Objective-C code to a git repository using a unified style format."
  s.homepage     = "https://github.com/square/spacecommander"
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors      = "Square, Inc."
  s.source       = { :git => "https://github.com/square/spacecommander.git", :tag => s.version }
  
  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.6"

  # Use this file to overcome CocoaPods limitation that at least one source file must be specified.
  s.source_files = "CocoaPodsDummy.m"

  s.preserve_paths = "**/*", ".clang-format"
end
