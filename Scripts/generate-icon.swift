#!/usr/bin/swift

import Cocoa

let s = CGSize(width: 1024, height: 1024)
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "Mulhim/Resources/Assets.xcassets/AppIcon.appiconset/icon.png"

let img = NSImage(size: s); img.lockFocus()
guard let ctx = NSGraphicsContext.current?.cgContext else { fatalError() }

// White background with subtle blue gradient
let bgColors = [
    CGColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1),
    CGColor(red: 0.85, green: 0.90, blue: 0.98, alpha: 1),
    CGColor(red: 0.90, green: 0.93, blue: 0.99, alpha: 1),
]
let bgGrad = CGGradient(colorsSpace: nil, colors: bgColors as CFArray, locations: [0, 0.5, 1])!
ctx.drawLinearGradient(bgGrad, start: CGPoint(x: 0, y: 0), end: CGPoint(x: s.width, y: s.height), options: [])

// Draw simple mosque icon with gold lines
ctx.setStrokeColor(CGColor(red: 0.82, green: 0.62, blue: 0.12, alpha: 1))
ctx.setLineWidth(6)
ctx.setShadow(offset: .zero, blur: 8, color: CGColor(red: 0.82, green: 0.62, blue: 0.12, alpha: 0.3))

// Main dome (large arc)
ctx.addArc(center: CGPoint(x: 512, y: 520), radius: 180, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()

// Small dome to the right
ctx.addArc(center: CGPoint(x: 670, y: 440), radius: 70, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()

// Small dome to the left
ctx.addArc(center: CGPoint(x: 354, y: 440), radius: 70, startAngle: 0, endAngle: .pi, clockwise: false)
ctx.strokePath()

// Minaret right
ctx.setLineWidth(5)
ctx.move(to: CGPoint(x: 740, y: 650))
ctx.addLine(to: CGPoint(x: 740, y: 300))
ctx.strokePath()

// Minaret top right
ctx.addEllipse(in: CGRect(x: 730, y: 280, width: 20, height: 20))
ctx.strokePath()

// Minaret left
ctx.move(to: CGPoint(x: 284, y: 650))
ctx.addLine(to: CGPoint(x: 284, y: 300))
ctx.strokePath()

// Minaret top left
ctx.addEllipse(in: CGRect(x: 274, y: 280, width: 20, height: 20))
ctx.strokePath()

// Base line
ctx.move(to: CGPoint(x: 250, y: 650))
ctx.addLine(to: CGPoint(x: 774, y: 650))
ctx.strokePath()

// Star/crescent on top of main dome
ctx.setLineWidth(4)
ctx.addArc(center: CGPoint(x: 512, y: 340), radius: 15, startAngle: 0, endAngle: .pi * 1.5, clockwise: false)
ctx.strokePath()

// Text "ملهم"
ctx.setShadow(offset: .zero, blur: 0, color: nil)
let text = "ملهم" as NSString
let font = NSFont(name: "HelveticaNeue-Bold", size: 70) ?? NSFont.boldSystemFont(ofSize: 70)
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.1)
shadow.shadowBlurRadius = 4
shadow.shadowOffset = NSSize(width: 0, height: 2)
let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: NSColor(red: 0.82, green: 0.62, blue: 0.12, alpha: 1), .shadow: shadow]
let tSize = text.size(withAttributes: attrs)
text.draw(in: NSRect(x: (s.width - tSize.width) / 2, y: 680, width: tSize.width, height: tSize.height), withAttributes: attrs)

img.unlockFocus()

guard let cg = img.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError() }
let bmp = NSBitmapImageRep(cgImage: cg)
guard let d = bmp.representation(using: .png, properties: [:]) else { fatalError() }
try? d.write(to: URL(fileURLWithPath: out))
print("Icon generated: \(out)")
