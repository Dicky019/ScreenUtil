//
//  UIKitExample.swift
//  ScreenUtil Examples
//
//  Comprehensive UIKit usage examples
//

import UIKit
import ScreenUtil

// MARK: - Basic UIKit Example

class BasicUIKitViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureScreenUtil()
  }
  
  private func configureScreenUtil() {
    // Configure ScreenUtil with design size (e.g., iPhone 13 Pro)
    ScreenUtil.shared.configure(with: .iPhone13Pro)
    
    // Optional: Use custom configuration
    // let customConfig = ScreenUtilConfiguration(
    //  designSize: CGSize(width: 390, height: 844),
    //  minTextAdapt: true,
    //  scalingLimits: .default
    // )
    // ScreenUtil.shared.configure(with: customConfig)
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    // MARK: - 1. Basic Scaling Examples
    
    // Create views with responsive sizing
    let headerView = createHeaderView()
    let cardView = createCardView()
    let buttonStackView = createButtonStack()
    let infoLabel = createInfoLabel()
    
    // Add to view hierarchy
    [headerView, cardView, buttonStackView, infoLabel].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - 2. Responsive Constraints
    NSLayoutConstraint.activate([
      // Header view - responsive positioning
      headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.h),
      headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.w),
      headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.w),
      headerView.heightAnchor.constraint(equalToConstant: 80.h),
      
      // Card view - centered with responsive size
      cardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 32.h),
      cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      cardView.widthAnchor.constraint(equalToConstant: 320.w),
      cardView.heightAnchor.constraint(equalToConstant: 200.h),
      
      // Button stack - responsive spacing
      buttonStackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24.h),
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.w),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.w),
      buttonStackView.heightAnchor.constraint(equalToConstant: 44.h),
      
      // Info label - bottom positioning
      infoLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 32.h),
      infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.w),
      infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.w),
    ])
  }
  
  // MARK: - UI Component Creation
  
  private func createHeaderView() -> UIView {
    let container = UIView()
    container.backgroundColor = .systemBlue
    container.layer.cornerRadius = 12.r
    
    let titleLabel = UILabel()
    titleLabel.text = "ScreenUtil UIKit Demo"
    titleLabel.textColor = .white
    titleLabel.font = .systemFont(ofSize: 24.sp, weight: .bold)
    titleLabel.textAlignment = .center
    
    container.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
    ])
    
    return container
  }
  
  private func createCardView() -> UIView {
    let card = UIView()
    card.backgroundColor = .secondarySystemBackground
    card.layer.cornerRadius = 16.r
    card.layer.shadowOffset = CGSize(width: 0, height: 2.h)
    card.layer.shadowRadius = 8.r
    card.layer.shadowOpacity = 0.1
    
    // Card content
    let iconView = UIImageView()
    iconView.image = UIImage(systemName: "star.fill")
    iconView.tintColor = .systemYellow
    iconView.contentMode = .scaleAspectFit
    
    let titleLabel = UILabel()
    titleLabel.text = "Responsive Design"
    titleLabel.font = .systemFont(ofSize: 18.sp, weight: .semibold)
    titleLabel.textColor = .label
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = "Automatically adapts to different screen sizes"
    subtitleLabel.font = .systemFont(ofSize: 14.sp)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 0
    
    [iconView, titleLabel, subtitleLabel].forEach {
      card.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      iconView.topAnchor.constraint(equalTo: card.topAnchor, constant: 20.h),
      iconView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 40.w),
      iconView.heightAnchor.constraint(equalToConstant: 40.h),
      
      titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16.h),
      titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20.w),
      titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20.w),
      
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.h),
      subtitleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20.w),
      subtitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20.w),
    ])
    
    return card
  }
  
  private func createButtonStack() -> UIStackView {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 16.w
    
    let primaryButton = createButton(title: "Primary", style: .primary)
    let secondaryButton = createButton(title: "Secondary", style: .secondary)
    
    stackView.addArrangedSubview(primaryButton)
    stackView.addArrangedSubview(secondaryButton)
    
    return stackView
  }
  
  private enum ButtonStyle {
    case primary, secondary
  }
  
  private func createButton(title: String, style: ButtonStyle) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16.sp, weight: .medium)
    button.layer.cornerRadius = 8.r
    
    switch style {
    case .primary:
      button.backgroundColor = .systemBlue
      button.setTitleColor(.white, for: .normal)
    case .secondary:
      button.backgroundColor = .clear
      button.setTitleColor(.systemBlue, for: .normal)
      button.layer.borderWidth = 1.w
      button.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // Add target for demonstration
    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    
    return button
  }
  
  private func createInfoLabel() -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 12.sp)
    label.textColor = .secondaryLabel
    
    // Demonstrate screen metrics access
    let metrics = ScreenUtil.shared.getScreenMetrics()
    label.text = """
        Screen Metrics:
        • Size: \(Int(metrics.width)) x \(Int(metrics.height)) pts
        • Scale: \(metrics.scale)x
        • Safe Area: T:\(Int(metrics.safeAreaInsets.top)) B:\(Int(metrics.safeAreaInsets.bottom))
        • Device: \(ScreenUtil.shared.deviceType)
        """
    
    return label
  }
  
  @objc private func buttonTapped(_ sender: UIButton) {
    // Demonstrate debug functionality
    ScreenUtil.shared.debug.printCurrentConfiguration()
    
    // Show alert with responsive sizing
    let alert = UIAlertController(
      title: "Button Tapped",
      message: "This alert demonstrates responsive design!",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

// MARK: - Advanced UIKit Examples

class AdvancedUIKitViewController: UIViewController {
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScrollView()
    setupAdvancedExamples()
  }
  
  private func setupScrollView() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
    ])
  }
  
  private func setupAdvancedExamples() {
    // MARK: - 1. Batch Operations Example
    createBatchOperationsExample()
    
    // MARK: - 2. Fast Scaling Example
    createFastScalingExample()
    
    // MARK: - 3. Custom Scaling Limits Example
    createScalingLimitsExample()
    
    // MARK: - 4. Performance Demonstration
    createPerformanceExample()
  }
  
  private func createBatchOperationsExample() {
    let sectionView = createSectionView(title: "Batch Operations")
    
    // Demonstrate batch scaling for multiple values
    let values = [10, 20, 30, 40, 50]
    let scaledWidths = ScreenUtil.shared.batchWidths(values)
    let scaledHeights = ScreenUtil.shared.batchHeights(values)
    
    // Create visual representation
    let containerView = UIView()
    containerView.backgroundColor = .systemGray6
    containerView.layer.cornerRadius = 8.r
    
    for (index, _) in values.enumerated() {
      let barView = UIView()
      barView.backgroundColor = .systemBlue
      barView.layer.cornerRadius = 2.r
      
      containerView.addSubview(barView)
      barView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
        barView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: (20.w + CGFloat(index) * 60.w)),
        barView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.h),
        barView.widthAnchor.constraint(equalToConstant: scaledWidths[index]),
        barView.heightAnchor.constraint(equalToConstant: scaledHeights[index])
      ])
    }
    
    sectionView.addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: sectionView.subviews.first!.bottomAnchor, constant: 16.h),
      containerView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20.w),
      containerView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -20.w),
      containerView.heightAnchor.constraint(equalToConstant: 100.h),
      containerView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -20.h)
    ])
    
    addSectionToContent(sectionView)
  }
  
  private func createFastScalingExample() {
    let sectionView = createSectionView(title: "Fast Scaling")
    
    // Demonstrate fast scaling operations
    let fastScale = ScreenUtil.shared.fastScale
    
    let gridContainer = UIView()
    gridContainer.backgroundColor = .systemGray6
    gridContainer.layer.cornerRadius = 8.r
    
    // Create a grid of squares with fast scaling
    let gridSize = 4
    for row in 0..<gridSize {
      for col in 0..<gridSize {
        let squareView = UIView()
        squareView.backgroundColor = UIColor(
          hue: CGFloat(row * gridSize + col) / CGFloat(gridSize * gridSize),
          saturation: 0.7,
          brightness: 0.9,
          alpha: 1.0
        )
        squareView.layer.cornerRadius = fastScale.radius(4)
        
        gridContainer.addSubview(squareView)
        squareView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          squareView.leadingAnchor.constraint(equalTo: gridContainer.leadingAnchor,
                                              constant: fastScale.width(10 + CGFloat(col) * 60)),
          squareView.topAnchor.constraint(equalTo: gridContainer.topAnchor,
                                          constant: fastScale.height(10 + CGFloat(row) * 40)),
          squareView.widthAnchor.constraint(equalToConstant: fastScale.width(50)),
          squareView.heightAnchor.constraint(equalToConstant: fastScale.height(30))
        ])
      }
    }
    
    sectionView.addSubview(gridContainer)
    gridContainer.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      gridContainer.topAnchor.constraint(equalTo: sectionView.subviews.first!.bottomAnchor, constant: 16.h),
      gridContainer.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20.w),
      gridContainer.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -20.w),
      gridContainer.heightAnchor.constraint(equalToConstant: 200.h),
      gridContainer.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -20.h)
    ])
    
    addSectionToContent(sectionView)
  }
  
  private func createScalingLimitsExample() {
    let sectionView = createSectionView(title: "Scaling Limits")
    
    // Demonstrate different scaling limit configurations
    let configs: [(String, ScalingLimits)] = [
      ("Default", .default),
      ("Strict", .strict),
      ("Relaxed", .relaxed)
    ]
    
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 16.w
    
    for (name, limits) in configs {
      let cardView = UIView()
      cardView.backgroundColor = .systemBackground
      cardView.layer.cornerRadius = 8.r
      cardView.layer.borderWidth = 1.w
      cardView.layer.borderColor = UIColor.systemGray4.cgColor
      
      let titleLabel = UILabel()
      titleLabel.text = name
      titleLabel.font = .systemFont(ofSize: 14.sp, weight: .medium)
      titleLabel.textAlignment = .center
      
      let detailLabel = UILabel()
      detailLabel.text = "Min: \(limits.minScale)\nMax: \(limits.maxScale)"
      detailLabel.font = .systemFont(ofSize: 12.sp)
      detailLabel.textColor = .secondaryLabel
      detailLabel.textAlignment = .center
      detailLabel.numberOfLines = 0
      
      [titleLabel, detailLabel].forEach {
        cardView.addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
      }
      
      NSLayoutConstraint.activate([
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12.h),
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8.w),
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8.w),
        
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.h),
        detailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8.w),
        detailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8.w),
        detailLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12.h)
      ])
      
      stackView.addArrangedSubview(cardView)
    }
    
    sectionView.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: sectionView.subviews.first!.bottomAnchor, constant: 16.h),
      stackView.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20.w),
      stackView.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -20.w),
      stackView.heightAnchor.constraint(equalToConstant: 80.h),
      stackView.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -20.h)
    ])
    
    addSectionToContent(sectionView)
  }
  
  private func createPerformanceExample() {
    let sectionView = createSectionView(title: "Performance Demo")
    
    let button = UIButton(type: .system)
    button.setTitle("Run Performance Test", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16.sp, weight: .medium)
    button.layer.cornerRadius = 8.r
    button.addTarget(self, action: #selector(runPerformanceTest), for: .touchUpInside)
    
    sectionView.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: sectionView.subviews.first!.bottomAnchor, constant: 16.h),
      button.centerXAnchor.constraint(equalTo: sectionView.centerXAnchor),
      button.widthAnchor.constraint(equalToConstant: 200.w),
      button.heightAnchor.constraint(equalToConstant: 44.h),
      button.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -20.h)
    ])
    
    addSectionToContent(sectionView)
  }
  
  @objc private func runPerformanceTest() {
    // Run performance benchmark
    ScreenUtil.shared.debug.benchmarkScalingOperations()
    
    // Show results in alert
    let alert = UIAlertController(
      title: "Performance Test Complete",
      message: "Check console output for detailed benchmark results",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  // MARK: - Helper Methods
  
  private func createSectionView(title: String) -> UIView {
    let sectionView = UIView()
    
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = .systemFont(ofSize: 18.sp, weight: .semibold)
    titleLabel.textColor = .label
    
    sectionView.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 20.h),
      titleLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20.w),
      titleLabel.trailingAnchor.constraint(equalTo: sectionView.trailingAnchor, constant: -20.w)
    ])
    
    return sectionView
  }
  
  private var lastSectionView: UIView?
  
  private func addSectionToContent(_ sectionView: UIView) {
    contentView.addSubview(sectionView)
    sectionView.translatesAutoresizingMaskIntoConstraints = false
    
    let topConstraint: NSLayoutConstraint
    if let lastSection = lastSectionView {
      topConstraint = sectionView.topAnchor.constraint(equalTo: lastSection.bottomAnchor, constant: 32.h)
    } else {
      topConstraint = sectionView.topAnchor.constraint(equalTo: contentView.topAnchor)
    }
    
    NSLayoutConstraint.activate([
      topConstraint,
      sectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      sectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
    
    // Update content view bottom constraint
    if let lastSection = lastSectionView {
      lastSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = false
    }
    sectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.h).isActive = true
    
    lastSectionView = sectionView
  }
}

// MARK: - Custom Views with ScreenUtil

class ResponsiveCardView: UIView {
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let actionButton = UIButton(type: .system)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = .secondarySystemBackground
    layer.cornerRadius = 16.r
    layer.shadowOffset = CGSize(width: 0, height: 4.h)
    layer.shadowRadius = 12.r
    layer.shadowOpacity = 0.1
    
    setupImageView()
    setupLabels()
    setupButton()
    setupConstraints()
  }
  
  private func setupImageView() {
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8.r
    imageView.backgroundColor = .systemGray5
  }
  
  private func setupLabels() {
    titleLabel.font = .systemFont(ofSize: 16.sp, weight: .semibold)
    titleLabel.textColor = .label
    titleLabel.numberOfLines = 2
    
    subtitleLabel.font = .systemFont(ofSize: 14.sp)
    subtitleLabel.textColor = .secondaryLabel
    subtitleLabel.numberOfLines = 3
  }
  
  private func setupButton() {
    actionButton.setTitle("Learn More", for: .normal)
    actionButton.titleLabel?.font = .systemFont(ofSize: 14.sp, weight: .medium)
    actionButton.backgroundColor = .systemBlue
    actionButton.setTitleColor(.white, for: .normal)
    actionButton.layer.cornerRadius = 6.r
  }
  
  private func setupConstraints() {
    [imageView, titleLabel, subtitleLabel, actionButton].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      // Image view
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.h),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.w),
      imageView.widthAnchor.constraint(equalToConstant: 60.w),
      imageView.heightAnchor.constraint(equalToConstant: 60.h),
      
      // Title label
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.h),
      titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.w),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.w),
      
      // Subtitle label
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.h),
      subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.w),
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.w),
      
      // Action button
      actionButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.h),
      actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.w),
      actionButton.widthAnchor.constraint(equalToConstant: 100.w),
      actionButton.heightAnchor.constraint(equalToConstant: 32.h),
      actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.h)
    ])
  }
  
  func configure(title: String, subtitle: String, image: UIImage?) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
    imageView.image = image
  }
}
