#!/usr/bin/swift

import Cocoa

let s = CGSize(width: 1024, height: 1024)
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Mulhim/Resources/Assets.xcassets/AppIcon.appiconset/icon.png"
let r = CGRect(origin: .zero, size: s)

let img = NSImage(size: s)
img.lockFocus()
guard let ctx = NSGraphicsContext.current?.cgContext else { fatalError() }

// Islamic green background
ctx.setFillColor(CGColor(red: 0.11, green: 0.26, blue: 0.15, alpha: 1))
ctx.fill(r)

// Subtle gold radial glow in center
let center = CGPoint(x: 512, y: 512)
let glowColors = [
    CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.15),
    CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.05),
    CGColor(red: 0.11, green: 0.26, blue: 0.15, alpha: 0),
]
let glowGrad = CGGradient(colorsSpace: nil, colors: glowColors as CFArray, locations: [0, 0.4, 1])!
ctx.drawRadialGradient(glowGrad, startCenter: center, startRadius: 0, endCenter: center, endRadius: 400, options: [])

// Decorative gold circle outline
ctx.setStrokeColor(CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.25))
ctx.setLineWidth(2)
ctx.strokeEllipse(in: r.insetBy(dx: 30, dy: 30))

ctx.setStrokeColor(CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.12))
ctx.setLineWidth(1)
ctx.strokeEllipse(in: r.insetBy(dx: 50, dy: 50))

// Islamic geometric ornament (subtle gold lines)
ctx.setStrokeColor(CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.08))
ctx.setLineWidth(1)
for i in 0..<8 {
    let angle = Double(i) * 45.0 * .pi / 180.0
    let startX = 512 + 200 * cos(angle)
    let startY = 512 + 200 * sin(angle)
    let endX = 512 - 200 * cos(angle)
    let endY = 512 - 200 * sin(angle)
    ctx.move(to: CGPoint(x: startX, y: startY))
    ctx.addLine(to: CGPoint(x: endX, y: endY))
    ctx.strokePath()
}

// Mosque silhouette at top (very subtle)
ctx.setStrokeColor(CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.15))
ctx.setLineWidth(2)
ctx.addArc(center: CGPoint(x: 512, y: 440), radius: 100, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()
ctx.addArc(center: CGPoint(x: 610, y: 400), radius: 45, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()
ctx.addArc(center: CGPoint(x: 414, y: 400), radius: 45, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()
ctx.move(to: CGPoint(x: 350, y: 530))
ctx.addLine(to: CGPoint(x: 674, y: 530))
ctx.strokePath()

// Minarets
ctx.setLineWidth(2)
ctx.move(to: CGPoint(x: 350, y: 530))
ctx.addLine(to: CGPoint(x: 350, y: 280))
ctx.strokePath()
ctx.move(to: CGPoint(x: 674, y: 530))
ctx.addLine(to: CGPoint(x: 674, y: 280))
ctx.strokePath()

// "ملهم" text in gold
let text = "ملهم" as NSString
let font = NSFont.systemFont(ofSize: 88, weight: .bold)
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.15)
shadow.shadowBlurRadius = 6
shadow.shadowOffset = NSSize(width: 0, height: 2)
let attrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 1),
    .shadow: shadow,
]
let tSize = text.size(withAttributes: attrs)
text.draw(
    in: NSRect(
        x: (s.width - tSize.width) / 2,
        y: (s.height - tSize.height) / 2 - 60,
        width: tSize.width,
        height: tSize.height
    ),
    withAttributes: attrs
)

// Bottom decorative line
ctx.setStrokeColor(CGColor(red: 0.83, green: 0.69, blue: 0.22, alpha: 0.3))
ctx.setLineWidth(2)
ctx.move(to: CGPoint(x: 362, y: 300))
ctx.addLine(to: CGPoint(x: 662, y: 300))
ctx.strokePath()

img.unlockFocus()

guard let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError() }
let bmp = NSBitmapImageRep(cgImage: cg)
guard let d = bmp.representation(using: .png, properties: [:]) else { fatalError() }
try? d.write(to: URL(fileURLWithPath: out))
print("Icon generated: \(out)")
