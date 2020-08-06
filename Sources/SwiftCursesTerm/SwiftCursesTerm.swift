import curses
import Foundation

public typealias SCTWindowId = Int
public typealias SCTColorPair = Int

public class SwiftCursesTerm {

    var windows = [OpaquePointer]()
    var colours = 0


    public init() {
        curses.setlocale(LC_CTYPE, "en_US.UTF-8");
        curses.newterm(nil, stderr, stdin)
        curses.use_default_colors()
        curses.start_color()
    }

    public func addStr(window: SCTWindowId? = nil, content: String, refresh: Bool = false) {
        if let window = window {
            curses.waddstr(windows[window - 1], content)
        } else {
            curses.addstr(content)
        }
        if refresh {
            self.refresh(window: window)
        }
    }

    public func newWindow(height: Int, width: Int, line: Int = 0, column: Int = 0) -> SCTWindowId {
        let win = newwin(Int32(height), Int32(width), Int32(line), Int32(column))
        if win == nil {
            return -1
        }
        windows.append(win!)
        return windows.count
    }
    
    public func deleteWindow(window: Int) {
        guard window >= 1 && windows.count >= window else { return }
        delwin(windows[window - 1])
        windows.remove(at: window - 1)
    }

    public func addStrTo(window: SCTWindowId? = nil, content: String, line: Int, column: Int, refresh: Bool = false) {
        self.move(window: window, line: line, column: column)
        self.addStr(window: window, content: content, refresh: refresh)
    }
    
    public func move(window: SCTWindowId?, line: Int, column: Int) {
        if let window = window {
            curses.wmove(windows[window - 1], Int32(line), Int32(column))
        } else {
            curses.move(Int32(line), Int32(column))
        }
    }
    
    public func refresh(window: SCTWindowId? = nil) {
        if let window = window {
            curses.wrefresh(windows[window - 1])
        } else {
            curses.refresh()
        }
    }

    public func defineColorPair(foreground: CursesColor, background: CursesColor) -> SCTColorPair {
        colours += 1
        init_pair(Int16(colours), Int16(foreground.rawValue), Int16(background.rawValue))
        return colours
    }

    public func setColor(window: SCTWindowId? = nil, colorPair color: SCTColorPair = 0) {
        var colorPair = TextAttribute.normal.cursesValue
        if color > 0 {
            colorPair = COLOR_PAIR(Int32(color))
        }
        if let window = window {
            curses.wattrset(windows[window - 1], colorPair)
        } else {
            attrset(colorPair)
        }
    }

    public func setAttributes(window: SCTWindowId? = nil, _ attrs: [TextAttribute], colorPair: SCTColorPair? = nil) {
        let attrsValues = attrs.map { $0.cursesValue }
        if attrsValues.count > 0 {
            var consolidatedAttr = attrsValues.first!
            for attribute in attrsValues {
                consolidatedAttr |= attribute
            }
            if let colorPair = colorPair {
                consolidatedAttr |= COLOR_PAIR(Int32(colorPair))
            }
            if let window = window {
                curses.wattrset(windows[window - 1],consolidatedAttr)
            } else {
                curses.attrset(consolidatedAttr)
            }
        } else {
            if let colorPair = colorPair {
                setColor(window: window, colorPair: colorPair)
            }
        }
    }

    public func setWindowColorPair(window: SCTWindowId? = nil, colorPair color: SCTColorPair = 0) {
        var colorPair = TextAttribute.normal.cursesValue
        if color > 0 {
            colorPair = COLOR_PAIR(Int32(color))
        }
        if let window = window {
            curses.wbkgd(windows[window - 1], chtype(colorPair))
        } else {
            bkgd(chtype(colorPair))
        }
    }

    public func resetAttributes() {
        setAttributes([TextAttribute.normal])
    }

    public func noDelay(window: SCTWindowId? = nil, _ active: Bool) {
        if let window = window {
            curses.nodelay(windows[window - 1], active)
        } else {
            curses.nodelay(stdscr, active)
        }
    }

    public func shutdown() {
        guard windows.count > 0 else { endwin(); return }
        for i in (1 ... windows.count).reversed() {
            deleteWindow(window: i)
        }
        endwin()
    }
    deinit { 
        shutdown()
    }
}
