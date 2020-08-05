public enum TextAttribute: UInt {
    case normal
    case attributes
    case charText
    case color
    case standOut
    case underline
    case reverse
    case blink
    case dim
    case bold
    case altCharSet
    case invisible
    case protected
    case horizontal
    case left
    case low
    case right
    case top
    case vertical

    static let NCURSES_ATTR_SHIFT = 8
    static func NCURSES_BITS(_ mask: UInt32, _ shift: UInt32) -> CInt { return CInt( mask << (shift + UInt32(NCURSES_ATTR_SHIFT))) }
    static let A_NORMAL = CInt(1) ^ CInt(1)
    static let A_ATTRIBUTES = NCURSES_BITS(~(UInt32(1) - UInt32(1)), 0)
    static let A_CHARTEXT = NCURSES_BITS(1, 0) - 1
    static let A_COLOR = NCURSES_BITS((1 << 8) - 1, 0)
    static let A_STANDOUT = NCURSES_BITS(1, 8)
    static let A_UNDERLINE = NCURSES_BITS(1, 9)
    static let A_REVERSE = NCURSES_BITS(1, 10)
    static let A_BLINK = NCURSES_BITS(1, 11)
    static let A_DIM = NCURSES_BITS(1, 12)
    static let A_BOLD = NCURSES_BITS(1, 13)
    static let A_ALTCHARSET = NCURSES_BITS(1, 14)
    static let A_INVIS = NCURSES_BITS(1, 15)
    static let A_PROTECT = NCURSES_BITS(1, 16)
    static let A_HORIZONTAL = NCURSES_BITS(1, 17)
    static let A_LEFT = NCURSES_BITS(1, 18)
    static let A_LOW = NCURSES_BITS(1, 19)
    static let A_RIGHT = NCURSES_BITS(1, 20)
    static let A_TOP = NCURSES_BITS(1, 21)
    static let A_VERTICAL = NCURSES_BITS(1, 22)

    var cursesValue: Int32 {
        switch self {
        case .normal: return TextAttribute.A_NORMAL
        case .attributes: return TextAttribute.A_ATTRIBUTES
        case .charText: return TextAttribute.A_CHARTEXT
        case .color: return TextAttribute.A_COLOR
        case .standOut: return TextAttribute.A_STANDOUT
        case .underline: return TextAttribute.A_UNDERLINE
        case .reverse: return TextAttribute.A_REVERSE
        case .blink: return TextAttribute.A_BLINK
        case .dim: return TextAttribute.A_DIM
        case .bold: return TextAttribute.A_BOLD
        case .altCharSet: return TextAttribute.A_ALTCHARSET
        case .invisible: return TextAttribute.A_INVIS
        case .protected: return TextAttribute.A_PROTECT
        case .horizontal: return TextAttribute.A_HORIZONTAL
        case .left: return TextAttribute.A_LEFT
        case .low: return TextAttribute.A_LOW
        case .right: return TextAttribute.A_RIGHT
        case .top: return TextAttribute.A_TOP
        case .vertical: return TextAttribute.A_VERTICAL
        }
    }
}
