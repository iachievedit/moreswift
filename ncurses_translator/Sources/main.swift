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
import Glibc

let interpreter = CommandInterpreter()
let translator  = Translator()

nc.addObserverForName(INPUT_NOTIFICATION, object:nil, queue:nil) {
  (_) in
  let tc = translationCommand
  CursesInterface.displayStatusBar("Translating")
  translator.translate(tc.text, from:tc.from, to:tc.to){
    translation, error in
    guard error == nil && translation != nil else {
      CursesInterface.displayTranslation("Translation failure:  \(error!.code)")
      return
    }
    CursesInterface.displayTranslation(translation!)
  }
}

nc.addObserverForName(QUIT_NOTIFICATION, object:nil, queue:nil) {
  (_) in
  CursesInterface.end()
}

CursesInterface.start()
while true {
  CursesInterface.setPrompt(interpreter.prompt)
  CursesInterface.displayStatusBar()
  let input   = CursesInterface.getInput()
  let command = interpreter.parseInput(input)
  interpreter.doCommand(command)
}

