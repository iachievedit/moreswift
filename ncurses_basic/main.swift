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

trap(.INT) { signal in
  endwin()
  exit(0)
}

initscr()
noecho()    // Turn on noecho, though it doesn't matter in this example
curs_set(0) // 0 is invisible, 1 is visible, 2 is very visible

move(0, 0)
addstr("UL")
refresh() // This is required to update the screen
move(23,78)
addstr("LR")
refresh()

select(0, nil, nil, nil, nil)

