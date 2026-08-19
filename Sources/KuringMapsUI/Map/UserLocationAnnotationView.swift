//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import MapKit

/// 내 위치 마커
final class UserLocationAnnotationView: MKAnnotationView {
    private let beamImageView = UIImageView()
    private let dotBackgroundView = UIView()
    private let dotView = UIView()

    private static let viewSize: CGFloat = 90
    private static let dotSize: CGFloat = 14

    private var beamImageColor: UIColor?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let size = Self.viewSize
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        centerOffset = .zero
        canShowCallout = false
        isEnabled = false
        displayPriority = .required

        beamImageView.frame = bounds
        beamImageView.contentMode = .center
        beamImageView.alpha = 0
        addSubview(beamImageView)

        let borderSize = Self.dotSize + 6
        dotBackgroundView.frame = CGRect(
            x: (size - borderSize) / 2,
            y: (size - borderSize) / 2,
            width: borderSize,
            height: borderSize
        )
        dotBackgroundView.backgroundColor = .white
        dotBackgroundView.layer.cornerRadius = borderSize / 2
        dotBackgroundView.layer.shadowColor = UIColor.black.cgColor
        dotBackgroundView.layer.shadowOpacity = 0.25
        dotBackgroundView.layer.shadowRadius = 3
        dotBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        addSubview(dotBackgroundView)

        dotView.frame = CGRect(x: 3, y: 3, width: Self.dotSize, height: Self.dotSize)
        dotView.layer.cornerRadius = Self.dotSize / 2
        dotBackgroundView.addSubview(dotView)
    }

    func configure(tintColor: UIColor, rotationDegrees: CLLocationDirection?) {
        if dotView.backgroundColor != tintColor {
            dotView.backgroundColor = tintColor
            beamImageColor = nil
        }

        guard let rotationDegrees else {
            beamImageView.alpha = 0
            return
        }

        if beamImageColor != tintColor {
            beamImageView.image = Self.makeBeamImage(size: bounds.size, color: tintColor)
            beamImageColor = tintColor
        }

        beamImageView.alpha = 1
        beamImageView.transform = CGAffineTransform(rotationAngle: rotationDegrees * .pi / 180)
    }

    private static func makeBeamImage(size: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = size.width / 2
            let coneHalfAngle: CGFloat = .pi / 6

            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(
                withCenter: center,
                radius: radius,
                startAngle: -CGFloat.pi / 2 - coneHalfAngle,
                endAngle: -CGFloat.pi / 2 + coneHalfAngle,
                clockwise: true
            )
            path.close()

            ctx.cgContext.saveGState()
            path.addClip()

            let colors = [color.withAlphaComponent(0.45).cgColor, color.withAlphaComponent(0.0).cgColor] as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1]) {
                ctx.cgContext.drawRadialGradient(
                    gradient,
                    startCenter: center, startRadius: 0,
                    endCenter: center, endRadius: radius,
                    options: []
                )
            }
            ctx.cgContext.restoreGState()
        }
    }
}
