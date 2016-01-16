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

func getmaxyx(window:UnsafeMutablePointer<WINDOW>, inout y:Int32, inout x:Int32) {
  x = getmaxx(window)
  y = getmaxy(window)
}

func getcuryx(window:UnsafeMutablePointer<WINDOW>, inout y:Int32, inout x:Int32) {
  x = getcurx(window)
  y = getcury(window)
}

func drawbox(numlines:Int32, numcols:Int32) {
  // Start at upper left and add characters to lower right
  for y in 0...numlines-1 {
    for x in 0...numcols {
      move(y, x)
      if y == 0 || y == numlines-1 {
        addch(UInt("*"))
      } else {
        if x == 0 || x == numcols {
          addch(UInt("*"))
        }
      }
    }
  }
  refresh()
}

func centerText(text:String, numlines:Int32, numcols:Int32) {
  let cy:Int32 = numlines/2
  let cx:Int32 = (numcols - Int32(text.characters.count))/2
  move(cy,cx)
  addstr(text)
  refresh()
}


trap(.INT) { signal in
  endwin()
  exit(0)
}

var maxy:Int32     = 0
var maxx:Int32     = 0

trap(.WINCH) { signal in
  endwin()
  refresh() 
  initscr()
  clear()
  noecho()

  getmaxyx(stdscr, y:&maxy, x:&maxx)
  drawbox(maxy, numcols:maxx)
  centerText("Hello world!", numlines:maxy, numcols:maxx)
}

initscr()
noecho()
curs_set(0)
getmaxyx(stdscr, y:&maxy, x:&maxx)

/*
// Extra credit, working with colors
start_color()
init_pair(1, Int16(COLOR_RED), Int16(COLOR_BLACK))
attron(COLOR_PAIR(1))
*/
drawbox(maxy, numcols:maxx)
centerText("Hello world!", numlines:maxy, numcols:maxx)

while true {
  select(0, nil, nil, nil, nil)
}

