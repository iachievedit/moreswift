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

import Glibc
import Foundation

public class Translator {

  let BUFSIZE = 1024

  public init() {
  }

  public func translate(text:String, from:String, to:String,
                        completion:(String?, NSError?) -> Void) {

    let curl = curl_easy_init()

    guard curl != nil else {
      completion(nil,
                 NSError(domain:"translator", code:1, userInfo:nil))
      return
    }

    let escapedText = curl_easy_escape(curl, text, Int32(strlen(text)))

    guard escapedText != nil else {
      completion(nil,
                 NSError(domain:"translator", code:2, userInfo:nil))
      return
    }
    
    let langPair = from + "%7c" + to
    let wgetCommand = "wget -qO- http://api.mymemory.translated.net/get\\?q\\=" + String(cString:escapedText!) + "\\&langpair\\=" + langPair
    
    let pp      = popen(wgetCommand, "r")
    var buf     = [CChar](repeating:0, count:BUFSIZE)
    
    var response:String = ""
    while fgets(&buf, Int32(BUFSIZE), pp) != nil {
      response = response + String(cString:buf)
    }
    
    let translated = translatedText(response)

    completion(String(cString:translated!),
               nil)
  }

}

