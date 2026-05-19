import SwiftUI
import GoogleMobileAds
import UIKit

struct BannerAdView: View {
    var body: some View {
        BannerAdContainer(adSize: AdSizeBanner)
            .frame(height: 50)
    }
}

private struct BannerAdContainer: UIViewRepresentable {
    let adSize: AdSize

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard !context.coordinator.didLoad else { return }
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?
            .keyWindow?
            .rootViewController else { return }

        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-9404799280370656/9988817066"
        bannerView.rootViewController = rootVC
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: uiView.centerYAnchor)
        ])
        bannerView.load(Request())
        context.coordinator.didLoad = true
    }

    final class Coordinator {
        var didLoad = false
    }
}
