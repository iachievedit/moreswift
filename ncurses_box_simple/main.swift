import Foundation
import CNCURSES
import Glibc

enum Signal:Int32 {
case INT   = 2
}

typealias SignalHandler = __sighandler_t

func trap(signum:Signal, action:SignalHandler) {
  signal(signum.rawValue, action)
}

func getmaxyx(window:UnsafeMutablePointer<WINDOW>, y:inout Int32, x:inout Int32) {
  x = getmaxx(window)
  y = getmaxy(window)
}

func getcuryx(window:UnsafeMutablePointer<WINDOW>, y:inout Int32, x:inout Int32) {
  x = getcurx(window)
  y = getcury(window)
}

func drawbox(numlines:Int32, numcols:Int32) {
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

func center(text:String, numlines:Int32, numcols:Int32) {
  let cy:Int32 = numlines/2
  let cx:Int32 = (numcols - Int32(text.characters.count))/2
  move(cy,cx)
  addstr(text)
  refresh()
}

trap(signum:.INT) { signal in
  endwin()
  exit(0)
}

var maxy:Int32     = 0
var maxx:Int32     = 0

initscr()
noecho()
curs_set(0)
getmaxyx(window:stdscr, y:&maxy, x:&maxx)

drawbox(numlines:maxy, numcols:maxx)
center(text:"Hello world!", numlines:maxy, numcols:maxx)

select(0, nil, nil, nil, nil)
endwin()

