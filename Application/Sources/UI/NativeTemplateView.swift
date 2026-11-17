//
//  NativeTemplateView.swift
//
//  Universal native template. One layout for every demand partner, adapting to
//  whatever assets the winning ad actually has: rows collapse when their data is
//  missing, the media box follows the ad's aspect ratio, and the AdChoices corner
//  is kept clear.
//
//  Usage:
//
//      nativeAd = try await Nimbus.inlineAd(position: "native") {
//          native { content, ad in
//              NativeTemplateView(content: content, ad: ad)
//          }
//      }
//
//  The `ad` getter is optional. With `native { content in NativeTemplateView(content: content) }`
//  the template renders the same, just without the hide button.
//
import UIKit
import NimbusKit

final class NativeTemplateView: UIView, NimbusKit.NativeAdView {

    let content: NativeAdContent

    /// nil = each network's default corner (top-right for AdMob, Meta and Vungle).
    let adChoicesPosition: NativeAdChoicesPosition?

    /// Getter for the ad this template belongs to.
    ///
    /// Safe to store: it holds the ad weakly, so it never keeps the ad alive, and it
    /// returns nil once the ad is gone. Call it when you need the ad (e.g. from a button
    /// action) and don't store what it returns. Avoid using the ad during init or
    /// layout, because Nimbus is still rendering at that point.
    private let ad: (@MainActor () -> Ad?)?

    // MARK: - Slots Nimbus fills

    let mediaContainer = UIView()
    private let iconSlot = UIView()
    var iconContainer: UIView? { content.hasIcon ? iconSlot : nil }

    // MARK: - Views this template fills

    private let headlineLabel = UILabel()
    private let advertiserLabel = UILabel()
    private let bodyLabel = UILabel()
    private let priceLabel = UILabel()
    private let storeLabel = UILabel()
    private let starRatingView = UIStackView()
    private let callToActionButton = UIButton(configuration: .filled())
    private let adBadge = NativeTemplateView.makeAdBadge()

    // MARK: - Template's own controls (not ad assets, never clickable for the ad)

    private let hideButton = UIButton(configuration: .plain())

    // MARK: - Layout containers

    private let rootStack = UIStackView()
    private let headerStack = UIStackView()
    private let textSection = UIStackView()
    private let priceStoreRow = UIStackView()
    private let detailsStack = UIStackView()
    private let footerStack = UIStackView()

    // MARK: - NativeAdView

    /// Only views that are showing content for this ad.
    var assetViews: [NativeAsset: UIView] {
        let all: [NativeAsset: UIView] = [
            .headline: headlineLabel,
            .body: bodyLabel,
            .advertiser: advertiserLabel,
            .price: priceLabel,
            .store: storeLabel,
            .starRating: starRatingView,
            .callToAction: callToActionButton,
        ]
        return all.filter { !$0.value.isHidden }
    }

    /// CTA, headline, icon and media, whichever of them this ad actually shows.
    /// The hide button is deliberately left out: tapping it must not count as an ad click.
    var clickableViews: [UIView] {
        let candidates: [UIView] = [callToActionButton, headlineLabel, iconSlot, mediaContainer]
        return candidates.filter { !$0.isHidden }
    }

    // MARK: - Init

    init(
        content: NativeAdContent,
        ad: (@MainActor () -> Ad?)?,
        adChoicesPosition: NativeAdChoicesPosition? = nil
    ) {
        self.content = content
        self.ad = ad
        self.adChoicesPosition = .bottomRight
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

        styleViews()
        buildHierarchy()
        configure(with: content)
        reserveAdChoicesCorner()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Styling

    private func styleViews() {
        iconSlot.layer.cornerRadius = 8
        iconSlot.clipsToBounds = true

        headlineLabel.font = .preferredFont(forTextStyle: .headline)
        headlineLabel.numberOfLines = 2

        advertiserLabel.font = .preferredFont(forTextStyle: .subheadline)
        advertiserLabel.textColor = .secondaryLabel
        advertiserLabel.numberOfLines = 1

        bodyLabel.font = .preferredFont(forTextStyle: .callout)
        bodyLabel.numberOfLines = 3

        for label in [priceLabel, storeLabel] {
            label.font = .preferredFont(forTextStyle: .footnote)
            label.textColor = .secondaryLabel
        }

        for label in [headlineLabel, advertiserLabel, bodyLabel, priceLabel, storeLabel] {
            label.adjustsFontForContentSizeCategory = true
        }

        mediaContainer.clipsToBounds = true
        mediaContainer.backgroundColor = .tertiarySystemFill

        starRatingView.axis = .horizontal
        starRatingView.spacing = 2
        let starConfig = UIImage.SymbolConfiguration(pointSize: 12)
        for _ in 0..<5 {
            let star = UIImageView()
            star.preferredSymbolConfiguration = starConfig
            star.tintColor = .systemOrange
            starRatingView.addArrangedSubview(star)
        }

        callToActionButton.configuration?.cornerStyle = .capsule
        callToActionButton.setContentHuggingPriority(.required, for: .horizontal)
        callToActionButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        hideButton.configuration?.image = UIImage(systemName: "xmark")
        hideButton.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        hideButton.configuration?.baseForegroundColor = .secondaryLabel
        hideButton.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        hideButton.accessibilityLabel = "Hide ad"
        hideButton.setContentHuggingPriority(.required, for: .horizontal)
        hideButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Only offered when the template was given the ad getter
        hideButton.isHidden = ad == nil
        hideButton.addAction(UIAction { [weak self] _ in
            self?.hideAd()
        }, for: .touchUpInside)
    }

    // MARK: - Using the ad

    /// Runs on tap, long after rendering finished, so it's safe to use the ad here.
    private func hideAd() {
        guard let currentAd = ad?() else { return }   // nil if the ad was already destroyed
        currentAd.destroy()
    }

    // MARK: - Hierarchy
    //
    // root (vertical)
    // ├─ textSection (vertical, 16pt side insets)
    // │  ├─ headerStack: [icon] [headline / "Ad" + advertiser] [hide]
    // │  └─ body
    // ├─ mediaContainer (full width)
    // └─ footerStack (16pt side insets): [stars / price · store] [CTA]
    //
    // UIStackView removes hidden arranged subviews from layout, so hiding a view
    // (or a whole row) is all it takes to collapse it.

    private func buildHierarchy() {
        let attributionRow = UIStackView(arrangedSubviews: [adBadge, advertiserLabel])
        attributionRow.axis = .horizontal
        attributionRow.spacing = 6
        attributionRow.alignment = .center

        let titleStack = UIStackView(arrangedSubviews: [headlineLabel, attributionRow])
        titleStack.axis = .vertical
        titleStack.spacing = 4

        // The hide button sits at the end of the header row. When AdChoices is in a top
        // corner, reserveAdChoicesCorner() insets this row, so the two never overlap.
        configureRow(headerStack, axis: .horizontal, spacing: 12, views: [iconSlot, titleStack, hideButton])
        headerStack.alignment = .center

        configureRow(textSection, axis: .vertical, spacing: 8, views: [headerStack, bodyLabel])
        textSection.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        configureRow(priceStoreRow, axis: .horizontal, spacing: 6, views: [priceLabel, storeLabel])

        configureRow(detailsStack, axis: .vertical, spacing: 4, views: [starRatingView, priceStoreRow])
        detailsStack.alignment = .leading

        configureRow(footerStack, axis: .horizontal, spacing: 12, views: [detailsStack, callToActionButton])
        footerStack.alignment = .center
        footerStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        configureRow(rootStack, axis: .vertical, spacing: 12, views: [textSection, mediaContainer, footerStack])
        rootStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)

        rootStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootStack)

        // Media follows the ad's aspect ratio. Portrait media gets a square box (the
        // network's media view letterboxes it), and very wide media is capped at 4:1.
        let ratio = min(max(content.mediaAspectRatio ?? 16.0 / 9.0, 1), 4)
        let mediaAspect = mediaContainer.heightAnchor.constraint(equalTo: mediaContainer.widthAnchor, multiplier: 1 / ratio)
        // Just below required, so a fixed-height container squeezes the media instead of breaking the layout.
        mediaAspect.priority = .required - 1

        NSLayoutConstraint.activate([
            rootStack.topAnchor.constraint(equalTo: topAnchor),
            rootStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootStack.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconSlot.widthAnchor.constraint(equalToConstant: 48),
            iconSlot.heightAnchor.constraint(equalToConstant: 48),

            mediaAspect,
            // AdMob demonetizes media views smaller than 120x120
            mediaContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
        ])
    }

    private func configureRow(_ stack: UIStackView, axis: NSLayoutConstraint.Axis, spacing: CGFloat, views: [UIView]) {
        stack.axis = axis
        stack.spacing = spacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .zero
        views.forEach(stack.addArrangedSubview)
    }

    // MARK: - Data

    private func configure(with content: NativeAdContent) {
        iconSlot.isHidden = !content.hasIcon

        setText(content.headline, on: headlineLabel)
        setText(content.advertiser, on: advertiserLabel)
        setText(content.body, on: bodyLabel)
        setText(content.price, on: priceLabel)
        setText(content.store, on: storeLabel)

        if let rating = content.starRating {
            setStars(rating)
            starRatingView.isHidden = false
        } else {
            starRatingView.isHidden = true
        }

        if let cta = nonEmpty(content.callToAction) {
            callToActionButton.configuration?.title = cta
            callToActionButton.isHidden = false
        } else {
            callToActionButton.isHidden = true
        }

        // Collapse whole rows when everything inside is missing.
        priceStoreRow.isHidden = priceLabel.isHidden && storeLabel.isHidden
        detailsStack.isHidden = starRatingView.isHidden && priceStoreRow.isHidden
        footerStack.isHidden = detailsStack.isHidden && callToActionButton.isHidden
        // headerStack always stays: the "Ad" badge is required attribution.
    }

    private func setText(_ text: String?, on label: UILabel) {
        let value = nonEmpty(text)
        label.text = value
        label.isHidden = value == nil
    }

    private func nonEmpty(_ text: String?) -> String? {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return nil }
        return text
    }

    private func setStars(_ rating: Double) {
        let clamped = min(max(rating, 0), 5)
        let full = Int(clamped.rounded(.down))
        let hasHalf = clamped - Double(full) >= 0.5

        for (index, view) in starRatingView.arrangedSubviews.enumerated() {
            let name: String
            if index < full {
                name = "star.fill"
            } else if index == full && hasHalf {
                name = "star.leadinghalf.filled"
            } else {
                name = "star"
            }
            (view as? UIImageView)?.image = UIImage(systemName: name)
        }

        starRatingView.isAccessibilityElement = true
        starRatingView.accessibilityLabel = String(format: "Rated %.1f out of 5", clamped)
    }

    // MARK: - AdChoices

    /// Keeps the corner where the network overlays its AdChoices icon clear of content.
    private func reserveAdChoicesCorner() {
        // AdMob, Meta and Vungle all default to top-right when nothing is set.
        let corner = adChoicesPosition ?? .topRight
        let reserved: CGFloat = 28

        switch corner {
        case .topRight:
            headerStack.directionalLayoutMargins.trailing = reserved
        case .topLeft:
            headerStack.directionalLayoutMargins.leading = reserved
        case .bottomRight:
            footerStack.directionalLayoutMargins.trailing += reserved
        case .bottomLeft:
            footerStack.directionalLayoutMargins.leading += reserved
        }
    }

    // MARK: - Ad attribution badge

    private static func makeAdBadge() -> UIView {
        let label = UILabel()
        label.text = "Ad"
        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false

        let badge = UIView()
        badge.backgroundColor = .tertiarySystemFill
        badge.layer.cornerRadius = 3
        badge.addSubview(label)
        badge.setContentHuggingPriority(.required, for: .horizontal)
        badge.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: badge.topAnchor, constant: 1),
            label.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -1),
            label.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -4),
        ])
        return badge
    }
}
