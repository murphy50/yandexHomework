import UIKit

enum ColorPalette {
    case backPrimary, backSecondary, elevated, iOSPrimary, blue, gray, grayLight, green, red, white, disable, labelPrimary, labelSecondary, tertiary, navbarBlur, overlay, separator
    
    var color: UIColor {
        get {
            switch self {
            case .backPrimary: return UIColor(named: "backPrimary")!
            case .backSecondary: return UIColor(named: "backSecondary")!
            case .elevated: return UIColor(named: "elevated")!
            case .iOSPrimary: return UIColor(named: "iOSPrimary")!
            case .blue: return UIColor(named: "blue")!
            case .gray: return UIColor(named: "gray")!
            case .grayLight: return UIColor(named: "grayLight")!
            case .green: return UIColor(named: "green")!
            case .red: return UIColor(named: "red")!
            case .white: return UIColor(named: "white")!
            case .disable: return UIColor(named: "disable")!
            case .labelPrimary: return UIColor(named: "labelPrimary")!
            case .labelSecondary: return UIColor(named: "labelSecondary")!
            case .tertiary: return UIColor(named: "tertiary")!
            case .navbarBlur: return UIColor(named: "navbarBlur")!
            case .overlay: return UIColor(named: "overlay")!
            case .separator: return UIColor(named: "overlay")!
            }
        }
    }
}
