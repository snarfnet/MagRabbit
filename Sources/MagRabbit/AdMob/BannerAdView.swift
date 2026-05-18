import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = BannerAdViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

class BannerAdViewController: UIViewController, GADBannerViewDelegate {
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Banner ad unit ID (replace with your actual ad unit ID)
        let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyyyyyy"
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self

        addBannerViewToView(bannerView)
        loadBannerAd()
    }

    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ]
        )
    }

    private func loadBannerAd() {
        let request = GADRequest()
        // Add test device ID for development
        // request.keywords = ["test"]
        bannerView.load(request)
    }

    // MARK: - GADBannerViewDelegate

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner ad loaded successfully")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner ad failed to load: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("Banner ad recorded impression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("Banner ad will present screen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("Banner ad will dismiss screen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("Banner ad dismissed screen")
    }
}

// MARK: - Interstitial Ad Manager

class InterstitialAdManager: NSObject, GADFullScreenContentDelegate {
    static let shared = InterstitialAdManager()
    var interstitialAd: GADInterstitialAd?
    private var displayCounter = 0
    private let displayFrequency = 3

    func loadInterstitialAd() {
        let adUnitID = "ca-app-pub-xxxxxxxxxxxxxxxx/zzzzzzzzzzzzzzzz"
        let request = GADRequest()

        GADInterstitialAd.load(
            withAdUnitID: adUnitID,
            request: request
        ) { ad, error in
            if let error = error {
                print("Interstitial ad failed to load: \(error.localizedDescription)")
                return
            }
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
            print("Interstitial ad loaded")
        }
    }

    func showInterstitialAdIfReady(from viewController: UIViewController) {
        displayCounter += 1

        if displayCounter >= displayFrequency {
            if let ad = interstitialAd {
                ad.present(fromRootViewController: viewController)
                displayCounter = 0
                loadInterstitialAd() // Load next ad
            }
        }
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial ad presented")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial ad dismissed")
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial ad failed to present: \(error.localizedDescription)")
    }
}
