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
import Foundation

let INPUT_NOTIFICATION   = Notification.Name(rawValue:"InputNotification")
let QUIT_NOTIFICATION    = Notification.Name(rawValue:"QuitNotification")
let nc = NotificationCenter.default

struct TranslationCommand {
  var from:String
  var to:String
  var text:String
}

var translationCommand:TranslationCommand = TranslationCommand(from:"en",
                                                               to:"es",
                                                               text:"")
                                          
