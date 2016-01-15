import PackageDescription

let package = Package(
  name:  "translator",
  dependencies: [
    .Package(url:  "https://github.com/iachievedit/CJSONC", majorVersion: 1),
    .Package(url:  "https://github.com/iachievedit/CNCURSES", majorVersion: 1),
    .Package(url:  "https://github.com/PureSwift/CcURL", majorVersion: 1)
  ]
)
