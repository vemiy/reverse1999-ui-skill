# iOS（SwiftUI / UIKit）

网页套件里的规则照搬，这里只写平台差异。数值全部来自 `assets/tokens.json`。

## 颜色

```swift
import SwiftUI

enum R99 {
    static let void   = Color(hex: 0x0B0A09)
    static let paper  = Color(hex: 0xE9DCCD)
    static let cream  = Color(hex: 0xFFFDE9)
    static let muted  = Color(hex: 0xC9C2B4)
    static let ink    = Color(hex: 0x171310)
    static let ink2   = Color(hex: 0x5B544B)
    static let rust   = Color(hex: 0xB55829)
    static let rustHi = Color(hex: 0xDB6F39)
    static let ok     = Color(hex: 0x8EC755)
    static let due    = Color(hex: 0xF56064)
    static let settled = Color(hex: 0x8C8D8C)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
```

跟随系统外观时用 `@Environment(\.colorScheme)` 切两套值；**不要**用 `.preferredColorScheme` 强制。

## 单角圆角

iOS 16 用 `UnevenRoundedRectangle`：

```swift
.padding(24)
.background(.black.opacity(0.82))
.overlay(
    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0,
                           bottomTrailingRadius: 0, topTrailingRadius: 30)
        .stroke(R99.rust, lineWidth: 1)
)
.clipShape(
    UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0,
                           bottomTrailingRadius: 0, topTrailingRadius: 30)
)
```

iOS 15 及以下用自定义 `Shape` 画路径，或者直接 `RoundedRectangle(cornerRadius: 30)` 再叠一层遮住左边两个角。

## 组件

```swift
struct R99Button: ButtonStyle {
    var primary = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("NotoSerifSC-Medium", size: 15))
            .tracking(1.2)
            .padding(.horizontal, 24)
            .frame(minHeight: 46)
            .foregroundColor(primary ? R99.cream : R99.cream)
            .background(primary ? R99.rust : Color.clear)
            .overlay(
                UnevenRoundedRectangle(topTrailingRadius: 10)
                    .stroke(primary ? R99.rust : R99.muted.opacity(0.32), lineWidth: 1)
            )
            .clipShape(UnevenRoundedRectangle(topTrailingRadius: 10))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
```

- 按钮高度 46pt，点击区域可以撑到 48。
- 按下态只降不透明度或改底色，**不要**加缩放。
- 记录行用 `.monospacedDigit()`，日期与编号才不会跳。

## 字体

- 中文：把 Noto Serif SC（或已授权的中文宋体）拖进工程，在 `Info.plist` 的 `UIAppFonts` 里登记，用 `.custom("NotoSerifSC-Bold", size: 28)`。
- 英文：Bodoni Moda（SIL OFL）。
- 没有自定义字体时，中文回退到 `UIFont(name: "Songti SC", size:)`；**不要**回退到系统无衬线，那套规则会立刻失效。

## 动效

```swift
.opacity(shown ? 1 : 0)
.offset(y: shown ? 0 : 32)
.animation(.easeOut(duration: 0.5), value: shown)
```

- 进入 0.5s，退出 0.35s；一组元素错开 0.06s。
- 尊重 `UIAccessibility.isReduceMotionEnabled`：为 true 时直接 `shown = true`。
- 不做弹簧、不做 3D 翻转。

## 竖排英文

```swift
Text("ARCHIVE OF THE LAST DAY")
    .font(.custom("BodoniModa-Regular", size: 11))
    .tracking(3.2)
    .rotationEffect(.degrees(180))
    .fixedSize()
    .rotation3DEffect(.degrees(0), axis: (0, 0, 1))
    .frame(width: 16)
    .rotationEffect(.degrees(-90))
```

更稳的做法是用 `Layout` 逐字竖排，或直接放一张预渲染的图；旋转后的可读性要给读屏补 `accessibilityLabel`。

## 纹理

`feTurbulence` 在 iOS 上不可用。把网页用的颗粒图导出成 160×160 的 PNG（可平铺），作为 `Image` 叠在背景上，`opacity 0.055`、`blendMode(.overlay)`。
雨丝同样导出一张 512×512 PNG，两层不同透明度，用 `LinearGradient` 遮罩到画面中心。
