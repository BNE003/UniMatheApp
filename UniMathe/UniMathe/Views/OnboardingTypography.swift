import SwiftUI

extension Font {
    static func onboarding(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .custom(OnboardingTypography.fontName(for: weight), size: size)
    }
}

enum OnboardingTypography {
    static func fontName(for weight: Font.Weight) -> String {
        switch weight {
        case .black, .heavy, .bold:
            return "Manrope-Bold"
        case .semibold:
            return "Manrope-SemiBold"
        case .medium:
            return "Manrope-Medium"
        default:
            return "Manrope-Regular"
        }
    }
}
