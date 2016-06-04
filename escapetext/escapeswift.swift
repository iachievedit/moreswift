import Foundation
import Glibc

guard Process.arguments.count == 2 else {
  print("Usage:  escapeswift STRING")
  exit(-1)
}

let string = Process.arguments[1]
var output:UnsafeMutablePointer<Int8>? = nil

let rc = escapeText(string, &output)

guard rc > 0 else {
  print("Error escaping text")
  exit(-1)
}

print("Escaped text:  \(String(cString:output!))")
exit(0)
