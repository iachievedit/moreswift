import Foundation
import Glibc

let inputNotificationName = Notification.Name(rawValue:"InputNotification")
let inputNotification = Notification(name:inputNotificationName, object:nil)
let nc = NotificationCenter.defaultCenter()

var availableData = ""
let readThread = Thread(){
  print("Entering thread... type something and have it echoed.")
  let delim:Character = "\n"
  var input:String    = ""
  while true {
    let c = Character(UnicodeScalar(UInt32(fgetc(stdin))))
    if c == delim {
      availableData = input
      nc.postNotification(inputNotification)
      input = ""
    } else {
      input.append(c)
    }
  }
  // Our read thread never exits
}

_ = nc.addObserverForName(inputNotificationName, object:nil, queue:nil) {
  (_) in
  print("Echo:  \(availableData)")
}

readThread.start()

select(0, nil, nil, nil, nil) // Forever sleep
