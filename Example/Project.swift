import ProjectDescription

let project = Project(
    name: "KuringMapsExample",
    packages: [
        .local(path: "../")
    ],
    targets: [
        Target(
            name: "KuringMapsExample",
            platform: .iOS,
            product: .app,
            bundleId: "com.kuring.maps.example",
            deploymentTarget: .iOS(targetVersion: "17.0", devices: [.iphone, .ipad]),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:],
                "NSLocationWhenInUseUsageDescription": "위치 정보를 사용하여 현재 위치를 지도에 표시합니다.",
            ]),
            sources: ["Sources/**"],
            dependencies: [
                .package(product: "KuringMapsUI"),
                .package(product: "KuringMapsLink")
            ]
        )
    ]
)
