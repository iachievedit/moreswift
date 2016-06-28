import PackageDescription

let package = Package(
  name:  "translator",
  dependencies: [
    .Package(url:  "https://github.com/iachievedit/CJSONC", majorVersion: 2),
    .Package(url:  "https://github.com/PureSwift/CcURL", majorVersion: 1, minor:0)
  ]
)
