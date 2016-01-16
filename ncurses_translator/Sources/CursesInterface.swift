// Copyright 2016 iAchieved.it LLC
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
import CNCURSES
import Glibc

enum Signal:Int32 {
case INT   = 2
case WINCH = 28
}

typealias SignalHandler = __sighandler_t

func trap(signum:Signal, action:SignalHandler) {
  signal(signum.rawValue, action)
}

func mvprintw(y y:Int32, x:Int32, str:String) -> Int32 {
  move(y,x)
  return addstr(str)
}

class CursesInterface {
  
  static let delim:Character     = "\n"
  static let backspace:Character = Character(UnicodeScalar(127))
  static let A_REVERSE = Int32(1 << 18)

  // Ncurses screen positions
  static var prompt:String  = ""
  static var maxy:Int32     = 0
  static var maxx:Int32     = 0
  static var cury:Int32     = 0
  static var curx:Int32     = 0
  static let inputCol:Int32 = 0

  static var liny:Int32 = 0

  class var statusLine:Int32 {
    get {
      return maxy - 2
    }
  }
  class var inputLine:Int32 {
    get {
      return maxy - 1
    }
  }
  class func start() {
    trap(.INT) { signal in
      CursesInterface.end()
    }
    trap(.WINCH) { signal in
      CursesInterface.reset()
      CursesInterface.getDisplaySize()
      CursesInterface.displayStatusBar(CursesInterface.prompt)
      CursesInterface.displayInput()
    }

    CursesInterface.reset()
    CursesInterface.getDisplaySize()
    CursesInterface.displayStatusBar(CursesInterface.prompt)
  }

  class func reset() {
    endwin()
    refresh()
    initscr()
    clear()
    noecho()
    curs_set(1)
    liny = 0
  }

  class func getDisplaySize() {
    maxx = getmaxx(stdscr)
    maxy = getmaxy(stdscr)
  }

  class func setPrompt(prompt:String) {
    CursesInterface.prompt = prompt
  }

  class func displayStatusBar(status:String = CursesInterface.prompt) {

    let cols = maxx
    let pad  = cols - status.characters.count - 1
    var paddedStatus = status
    for _ in 1...pad {
      paddedStatus += " "
    }
    
    move(statusLine, 0)
    attron(A_REVERSE)
    addstr(paddedStatus)
    addch(UInt(" "))
    attroff(A_REVERSE)
    refresh()

  }

  class func displayTranslation(translation:String) {
    move(liny, 0); liny += 1
    addstr(translation)
    refresh()
  }

  class func end() {
    endwin()
    exit(0)
  }

  static var input:String = ""
  class func getInput() -> String {
    input = ""
    curx = inputCol
    move(inputLine, curx)
    refresh()
    while true {
      let ic = UInt32(getch())
      let c  = Character(UnicodeScalar(ic))
      switch c {
      case backspace:
        guard curx != inputCol else { break }
        curx -= 1; move(inputLine, curx)
        delch()
        refresh()
        input = String(input.characters.dropLast())
      case delim:
        clearline(inputLine)
        return input
      default:
        if isprint(Int32(ic)) != 0 {
          addch(UInt(ic)); curx += 1
          refresh()
          input.append(c)
        }
      }
    }
  }

  class func displayInput() {
    // We assume that SIGWINCH has been received and we need to redraw our
    // input bar.  input contains the contents of the current buffer.
    mvprintw(y:inputLine, x:0, str:input)
    //move(inputLine, 0)
    //addstr(input)
    refresh()
    
  }

  class func clearline(lineno:Int32) {
    move(lineno, 0)
    clrtoeol()
    refresh()
  }

}
