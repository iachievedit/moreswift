import Foundation
import Glibc

let INPUT_NOTIFICATION = "InputNotification"
let nc = NSNotificationCenter.defaultCenter()

var availableData = ""
let readThread = NSThread(){
  print("Entering thread")
  let delim:Character = "\n"
  var input:String    = ""
  while true {
    let c = Character(UnicodeScalar(UInt32(fgetc(stdin))))
    if c == delim {
      availableData = input
      nc.postNotificationName(INPUT_NOTIFICATION, object:nil)
      input = ""
    } else {
      input.append(c)
    }
  }
  // Our read thread never exits
}

nc.addObserverForName(INPUT_NOTIFICATION, object:nil, queue:nil) {
  (_) in
  print("Data received:  \(availableData)")
}

readThread.start()

select(0, nil, nil, nil, nil) // Forever sleep
