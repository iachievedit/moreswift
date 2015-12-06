import Glibc

guard Process.arguments.count == 2 else {
  print("Usage:  swiftcat FILENAME")
  exit(-1)
}

let filename = Process.arguments[1]

let BUFSIZE = 1024
var pp      = popen("cat " + filename, "r")
var buf     = [CChar](count:BUFSIZE, repeatedValue:CChar(0))

while fgets(&buf, Int32(BUFSIZE), pp) != nil {
  print(String.fromCString(buf)!, terminator:"")
}

exit(0)
