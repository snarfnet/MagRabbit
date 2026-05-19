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

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-9404799280370656/9988817066"
        bannerView.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }?
            .rootViewController
        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
