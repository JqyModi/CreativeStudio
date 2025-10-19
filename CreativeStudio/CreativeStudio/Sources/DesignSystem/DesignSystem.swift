import SwiftUI

// MARK: - Color System
extension Color {
    static let primary = Color(hex: "#6A11CB")
    static let secondary = Color(hex: "#2575FC")
    static let accent = Color(hex: "#FF6B6B")
    static let success = Color(hex: "#4ECDC4")
    static let warning = Color(hex: "#FFD166")
    
    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [Color.primary, Color.secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let successGradient = LinearGradient(
        colors: [Color.success, Color(hex: "#43BCCD")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Semantic colors
    static let background = Color(.systemBackground)
    static let surface = Color(.systemGray6)
    static let onSurface = Color(.label)
    static let onSurfaceSecondary = Color(.secondaryLabel)
    
    // Status colors
    static let error = Color.red
    static let info = Color.blue
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
extension Font {
    static let displayLarge = Font.largeTitle.weight(.bold)
    static let displayMedium = Font.title.weight(.bold)
    static let displaySmall = Font.title2.weight(.semibold)
    
    static let headlineLarge = Font.headline.weight(.semibold)
    static let headlineMedium = Font.title3.weight(.semibold)
    static let headlineSmall = Font.headline.weight(.semibold)
    
    static let bodyLarge = Font.body
    static let bodyMedium = Font.callout
    static let bodySmall = Font.caption
    
    static let labelLarge = Font.subheadline.weight(.medium)
    static let labelMedium = Font.footnote.weight(.medium)
    static let labelSmall = Font.caption.weight(.medium)
}

// MARK: - Spacing System
enum Spacing: CGFloat, CaseIterable {
    case xxxs = 2
    case xxs = 4
    case xs = 8
    case s = 12
    case m = 16
    case l = 24
    case xl = 32
    case xxl = 40
    case xxxl = 48
    
    var points: CGFloat {
        return self.rawValue
    }
}

// MARK: - Corner Radius System
enum CornerRadius: CGFloat, CaseIterable {
    case xs = 4
    case s = 8
    case m = 12
    case l = 16
    case xl = 24
    case pill = 999
    case circular = 10000  // Using a large number instead of infinity
    
    var points: CGFloat {
        return self.rawValue
    }
}

// MARK: - Elevation System
enum Elevation: CGFloat {
    case none = 0
    case low = 2
    case medium = 4
    case high = 8
    case veryHigh = 16
    
    var radius: CGFloat {
        return self.rawValue
    }
    
    var color: Color {
        return Color.black.opacity(0.1)
    }
}

// MARK: - Animation System
enum AnimationDuration: Double {
    case fast = 0.1
    case normal = 0.3
    case slow = 0.5
    case verySlow = 1.0
}

// MARK: - Shadow System
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    static let low = ShadowStyle(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    static let medium = ShadowStyle(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    static let high = ShadowStyle(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
    
    func shadow() -> some ViewModifier {
        return ShadowModifier(style: self)
    }
}

struct ShadowModifier: ViewModifier {
    let style: ShadowStyle
    
    func body(content: Content) -> some View {
        content
            .shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}

// MARK: - Custom View Modifiers
extension View {
    func cornerRadius(_ radius: CornerRadius) -> some View {
        return self.cornerRadius(radius.points)
    }
    
    func padding(_ edges: Edge.Set = .all, _ length: Spacing) -> some View {
        return self.padding(edges, length.points)
    }
    
    func shadow(_ style: ShadowStyle) -> some View {
        return self.modifier(style.shadow())
    }
    
    func animatedOpacity(duration: AnimationDuration = .normal) -> some View {
        return self.animation(.easeInOut(duration: duration.rawValue), value: UUID())
    }
    
    func roundedCorners(_ corners: UIRectCorner, radius: CGFloat) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Helper Shapes
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Component Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(.l)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.surface)
            .foregroundColor(Color.onSurface)
            .cornerRadius(.l)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.l.points)
                    .stroke(Color.primary, lineWidth: 2)
            )
            .foregroundColor(Color.primary)
            .cornerRadius(.l)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Preview Provider
#Preview {
    VStack(spacing: Spacing.m.points) {
        Text("Design System Showcase")
            .font(.displayLarge)
        
        // Color examples
        VStack(alignment: .leading, spacing: Spacing.xs.points) {
            Text("Colors:")
                .font(.headlineMedium)
            
            HStack {
                Color.primary
                    .frame(width: 50, height: 50)
                    .cornerRadius(.s)
                Text("Primary")
            }
            
            HStack {
                Color.secondary
                    .frame(width: 50, height: 50)
                    .cornerRadius(.s)
                Text("Secondary")
            }
            
            HStack {
                Color.accent
                    .frame(width: 50, height: 50)
                    .cornerRadius(.s)
                Text("Accent")
            }
        }
        
        // Typography examples
        VStack(alignment: .leading, spacing: Spacing.xs.points) {
            Text("Typography:")
                .font(.headlineMedium)
            
            Text("Display Large").font(.displayLarge)
            Text("Headline Medium").font(.headlineMedium)
            Text("Body Large").font(.bodyLarge)
            Text("Label Small").font(.labelSmall)
        }
        
        // Button examples
        VStack(alignment: .leading, spacing: Spacing.xs.points) {
            Text("Buttons:")
                .font(.headlineMedium)
            
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle())
            
            Button("Secondary Button") {}
                .buttonStyle(SecondaryButtonStyle())
            
            Button("Outline Button") {}
                .buttonStyle(OutlineButtonStyle())
        }
    }
    .padding()
}