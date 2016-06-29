import PackageDescription

let package = Package(
  name:  "ncurses_box_simple",
  dependencies: [
    .Package(url:  "https://github.com/iachievedit/CNCURSES", majorVersion: 2),
  ]
)
