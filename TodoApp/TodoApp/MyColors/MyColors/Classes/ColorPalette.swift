import UIKit

public enum ColorPalette {
    
    case backPrimary, backSecondary, elevated, iOSPrimary, blue, gray, grayLight, green, red, white, disable, labelPrimary, labelSecondary, tertiary, navbarBlur, overlay, separator

    public var color: UIColor {
        let bundlePath = Bundle(identifier: "com.murphy.colorPalette")!.path(forResource: "Resources", ofType: "bundle")!
        let bundle = Bundle(url: URL(fileURLWithPath: bundlePath))
        switch self {
        case .backPrimary: return  UIColor(named: "backPrimary", in: bundle, compatibleWith: nil)!
        case .backSecondary: return UIColor(named: "backSecondary", in: bundle, compatibleWith: nil)!
        case .elevated: return UIColor(named: "elevated", in: bundle, compatibleWith: nil)!
        case .iOSPrimary: return UIColor(named: "iOSPrimary", in: bundle, compatibleWith: nil)!
        case .blue: return UIColor(named: "blue", in: bundle, compatibleWith: nil)!
        case .gray: return UIColor(named: "gray", in: bundle, compatibleWith: nil)!
        case .grayLight: return UIColor(named: "grayLight", in: bundle, compatibleWith: nil)!
        case .green: return UIColor(named: "green", in: bundle, compatibleWith: nil)!
        case .red: return UIColor(named: "red", in: bundle, compatibleWith: nil)!
        case .white: return UIColor(named: "white", in: bundle, compatibleWith: nil)!
        case .disable: return UIColor(named: "disable", in: bundle, compatibleWith: nil)!
        case .labelPrimary: return UIColor(named: "labelPrimary", in: bundle, compatibleWith: nil)!
        case .labelSecondary: return UIColor(named: "labelSecondary", in: bundle, compatibleWith: nil)!
        case .tertiary: return UIColor(named: "tertiary", in: bundle, compatibleWith: nil)!
        case .navbarBlur: return UIColor(named: "navbarBlur", in: bundle, compatibleWith: nil)!
        case .overlay: return UIColor(named: "overlay", in: bundle, compatibleWith: nil)!
        case .separator: return UIColor(named: "overlay", in: bundle, compatibleWith: nil)!
        }
    }
}
