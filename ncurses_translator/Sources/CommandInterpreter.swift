// Copyright 2015 iAchieved.it LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Import statements
import Foundation
import Glibc

// Enumerations
enum CommandType {
case None
case Translate
case SetFrom
case SetTo
case Quit
}

// Structs
struct Command {
  var type:CommandType
  var data:String
}

// Classes
class CommandInterpreter {

  // Read-only computed property
  var prompt:String {
    return "\(translationCommand.from)->\(translationCommand.to)"
  }
  
  init() {
  }
  
  func parseInput(input:String) -> Command {
    var commandType:CommandType
    var commandData:String = ""

    // Splitting a string
    let tokens = input.characters.split{$0 == " "}.map(String.init)

    // guard statement to validate that there are tokens
    guard tokens.count > 0 else {
      return Command(type:CommandType.None, data:"")
    }
    
    switch tokens[0] {
    case "/quit":
      commandType = .Quit
    case "/from":
      guard tokens.count == 2 else {
        return Command(type:.None, data:"")
      }
      commandType = .SetFrom
      commandData = tokens[1]
    case "/to":
      guard tokens.count == 2 else {
        return Command(type:.None, data:"")
      }
      commandType = .SetTo
      commandData = tokens[1]
    default:
      commandType = .Translate
      commandData = input
    }
    return Command(type:commandType, data:commandData)
  }

  func doCommand(command:Command) {
    switch command.type {
    case .Quit:
      nc.post(Notification(name:QUIT_NOTIFICATION, object:nil))
    case .SetFrom:
      translationCommand.from = command.data
    case .SetTo:
      translationCommand.to   = command.data
    case .Translate:
      translationCommand.text = command.data
      nc.post(Notification(name:INPUT_NOTIFICATION, object:nil))
    case .None:
      break
    }
  }
}

