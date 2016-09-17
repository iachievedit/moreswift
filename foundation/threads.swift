import Foundation
import Glibc

var done = false 
let thread = Thread(){
  print("Entering thread")
  for i in (1...10).reversed() {
    print("\(i)...", terminator:"")
    fflush(stdout)
    sleep(1)
  }
  print("Exiting thread") 
  done = true
}

thread.start()

while !done {
  sleep(1)
}
