import Glibc

guard CommandLine.arguments.count == 2 else {
  print("Usage:  swiftcat FILENAME")
  exit(-1)
}

let filename = CommandLine.arguments[1]

let BUFSIZE = 1024
var pp      = popen("cat " + filename, "r")
var buf     = [CChar](repeating:0, count:BUFSIZE)

while fgets(&buf, Int32(BUFSIZE), pp) != nil {
  print(String(cString:buf), terminator:"")
}

exit(0)
