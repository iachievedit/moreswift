import PackageDescription

let package = Package(
  name:  "ncurses_basic",
  dependencies: [
    .Package(url:  "https://github.com/iachievedit/CNCURSES", majorVersion: 2),
  ]
)
