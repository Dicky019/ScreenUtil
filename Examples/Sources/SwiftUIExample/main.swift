//
//  SwiftUIExample.swift
//  ScreenUtil Examples
//
//  Comprehensive SwiftUI usage examples
//

import SwiftUI
import ScreenUtil

// MARK: - Basic SwiftUI Example

struct BasicSwiftUIView: View {
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24.h) {
          // MARK: - Header Section
          headerSection
          
          // MARK: - Feature Cards
          featuresSection
          
          // MARK: - Interactive Elements
          interactiveSection
          
          // MARK: - Info Section
          infoSection
        }
        .padding(.horizontal, 20.w)
        .padding(.top, 16.h)
      }
      .navigationTitle("ScreenUtil SwiftUI")
      .navigationBarTitleDisplayMode(.large)
    }
    .onAppear {
      configureScreenUtil()
    }
  }
  
  private func configureScreenUtil() {
    let screenUtil = ScreenUtil.shared
    // Configure with iPhone 13 Pro design size
    screenUtil.configure(with: .iPhone13Pro)
    
    // Optional: Print current configuration for debugging
    screenUtil.debug.printCurrentConfiguration()
  }
  
  // MARK: - Header Section
  
  private var headerSection: some View {
    VStack(spacing: 12.h) {
      Image(systemName: "iphone.gen3")
        .font(.system(size: 48.sp))
        .foregroundColor(.blue)
      
      Text("Responsive Design")
        .font(.scaledSystem(size: 28, weight: .bold))
        .multilineTextAlignment(.center)
      
      Text("Built with ScreenUtil for perfect adaptation across all devices")
        .font(.scaledSystem(size: 16))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .lineLimit(3)
    }
    .padding(.vertical, 24.h)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16.r)
        .fill(Color.blue.opacity(0.1))
    )
  }
  
  // MARK: - Features Section
  
  private var featuresSection: some View {
    VStack(spacing: 16.h) {
      HStack {
        Text("Features")
          .font(.scaledSystem(size: 22, weight: .semibold))
        Spacer()
      }
      
      LazyVGrid(columns: [
        GridItem(.flexible(), spacing: 12.w),
        GridItem(.flexible(), spacing: 12.w)
      ], spacing: 12.h) {
        FeatureCard(
          icon: "scalemass",
          title: "Auto Scaling",
          description: "Automatically scales all elements"
        )
        
        FeatureCard(
          icon: "speedometer",
          title: "High Performance",
          description: "Optimized for 60fps animations"
        )
        
        FeatureCard(
          icon: "shield.checkered",
          title: "Thread Safe",
          description: "Safe concurrent access guaranteed"
        )
        
        FeatureCard(
          icon: "gearshape.2",
          title: "Configurable",
          description: "Flexible scaling limits and options"
        )
      }
    }
  }
  
  // MARK: - Interactive Section
  
  private var interactiveSection: some View {
    VStack(spacing: 20.h) {
      HStack {
        Text("Interactive Demo")
          .font(.scaledSystem(size: 22, weight: .semibold))
        Spacer()
      }
      
      // Responsive buttons
      HStack(spacing: 12.w) {
        ResponsiveButton(
          title: "Primary",
          style: .primary,
          action: { print("Primary button tapped") }
        )
        
        ResponsiveButton(
          title: "Secondary",
          style: .secondary,
          action: { print("Secondary button tapped") }
        )
      }
      
      // Scaling demonstration
      ScalingDemoView()
      
      // Performance test
      NavigationLink(destination: PerformanceDemoView()) {
        HStack {
          Image(systemName: "timer")
          Text("Performance Tests")
          Spacer()
          Image(systemName: "chevron.right")
        }
        .font(.scaledSystem(size: 16, weight: .medium))
        .padding(.horizontal, 16.w)
        .padding(.vertical, 12.h)
        .background(
          RoundedRectangle(cornerRadius: 8.r)
            .fill(Color.green.opacity(0.1))
        )
        .foregroundColor(.green)
      }
    }
  }
  
  // MARK: - Info Section
  
  private var infoSection: some View {
    VStack(alignment: .leading, spacing: 12.h) {
      Text("Screen Metrics")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      InfoRow(label: "Screen Size", value: "\(Int(ScreenUtil.shared.getScreenMetrics().width)) x \(Int(ScreenUtil.shared.getScreenMetrics().height)) pts")
      InfoRow(label: "Scale Factor", value: "\(ScreenUtil.shared.getScreenMetrics().scale)x")
      InfoRow(label: "Safe Area Top", value: "\(Int(ScreenUtil.shared.getScreenMetrics().safeAreaInsets.top)) pts")
      InfoRow(label: "Safe Area Bottom", value: "\(Int(ScreenUtil.shared.getScreenMetrics().safeAreaInsets.bottom)) pts")
      InfoRow(label: "Device Type", value: "\(ScreenUtil.shared.deviceType)")
      InfoRow(label: "Width Scale", value: String(format: "%.3f", ScreenUtil.shared.scaleWidth))
      InfoRow(label: "Height Scale", value: String(format: "%.3f", ScreenUtil.shared.scaleHeight))
      InfoRow(label: "Text Scale", value: String(format: "%.3f", ScreenUtil.shared.scaleText))
    }
    .padding(16.w)
    .background(
      RoundedRectangle(cornerRadius: 12.r)
        .fill(Color.secondary.opacity(0.1))
    )
  }
}

// MARK: - Feature Card Component

struct FeatureCard: View {
  let icon: String
  let title: String
  let description: String
  
  var body: some View {
    VStack(spacing: 8.h) {
      Image(systemName: icon)
        .font(.system(size: 24.sp))
        .foregroundColor(.blue)
      
      Text(title)
        .font(.scaledSystem(size: 14, weight: .semibold))
        .lineLimit(1)
      
      Text(description)
        .font(.scaledSystem(size: 12))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16.h)
    .padding(.horizontal, 12.w)
    .background(
      RoundedRectangle(cornerRadius: 12.r)
        .fill(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 4.r, y: 2.h)
    )
  }
}

// MARK: - Responsive Button Component

struct ResponsiveButton: View {
  let title: String
  let style: ButtonStyle
  let action: () -> Void
  
  enum ButtonStyle {
    case primary, secondary
  }
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.scaledSystem(size: 16, weight: .medium))
        .foregroundColor(style == .primary ? .white : .blue)
        .frame(maxWidth: .infinity)
        .frame(height: 44.h)
        .background(
          RoundedRectangle(cornerRadius: 8.r)
            .fill(style == .primary ? Color.blue : Color.clear)
            .overlay(
              RoundedRectangle(cornerRadius: 8.r)
                .stroke(Color.blue, lineWidth: style == .secondary ? 1.w : 0)
            )
        )
    }
  }
}

// MARK: - Scaling Demo Component

struct ScalingDemoView: View {
  @State private var selectedScale: ScaleType = .width
  private let scaleTypes: [ScaleType] = [.width, .height, .text, .radius]
  
  var body: some View {
    VStack(spacing: 16.h) {
      Text("Scaling Types Demo")
        .font(.scaledSystem(size: 16, weight: .medium))
      
      // Scale type picker
      Picker("Scale Type", selection: $selectedScale) {
        ForEach(scaleTypes, id: \.self) { scaleType in
          Text(String(describing: scaleType).capitalized)
            .tag(scaleType)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      
      // Visual demonstration
      HStack(spacing: 16.w) {
        ForEach(1...5, id: \.self) { index in
          let baseValue: CGFloat = CGFloat(index * 20)
          let scaledValue = ScreenUtil.shared.scale(for: baseValue, scaleType: selectedScale)
          
          VStack(spacing: 4.h) {
            Rectangle()
              .fill(Color.blue)
              .frame(width: 20.w, height: scaledValue)
            
            Text("\(Int(scaledValue))")
              .font(.scaledSystem(size: 10))
              .foregroundColor(.secondary)
          }
        }
      }
      .frame(height: 120.h)
      .padding(16.w)
      .background(
        RoundedRectangle(cornerRadius: 8.r)
          .fill(Color.gray.opacity(0.1))
      )
    }
  }
}

// MARK: - Info Row Component

struct InfoRow: View {
  let label: String
  let value: String
  
  var body: some View {
    HStack {
      Text(label)
        .font(.scaledSystem(size: 14))
        .foregroundColor(.secondary)
      
      Spacer()
      
      Text(value)
        .font(.scaledSystem(size: 14, weight: .medium))
    }
  }
}

// MARK: - Advanced SwiftUI Examples

struct AdvancedSwiftUIView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink("Property Wrappers", destination: PropertyWrappersDemo())
        NavigationLink("View Modifiers", destination: ViewModifiersDemo())
        NavigationLink("Responsive Layout", destination: ResponsiveLayoutDemo())
        NavigationLink("Custom Components", destination: CustomComponentsDemo())
      }
      .navigationTitle("Advanced Examples")
    }
  }
}

// MARK: - Property Wrappers Demo

struct PropertyWrappersDemo: View {
  @ScaledValue(wrappedValue: 100, .width) private var scaledWidth
  @ScaledValue(wrappedValue:50, .height) private var scaledHeight
  @ScaledValue(wrappedValue:16, .font) private var scaledFontSize
  @ScreenPercentage(wrappedValue:25, .width) private var screenPercentage
  
  var body: some View {
    VStack(spacing: 24.h) {
      Text("Property Wrappers Demo")
        .font(.scaledSystem(size: 24, weight: .bold))
      
      VStack(alignment: .leading, spacing: 16.h) {
        PropertyWrapperCard(
          title: "@ScaledValue",
          description: "Automatically scales values based on screen size",
          example: "Width: \(Int(scaledWidth)), Height: \(Int(scaledHeight))"
        )
        
        PropertyWrapperCard(
          title: "@ScreenPercentage",
          description: "Uses percentage of screen dimensions",
          example: "25% of screen width: \(Int(screenPercentage))"
        )
        
        PropertyWrapperCard(
          title: "@ResponsiveFont",
          description: "Scales font size automatically",
          example: "Font size: \(Int(scaledFontSize))sp"
        )
      }
      
      Spacer()
    }
    .padding(20.w)
    .navigationTitle("Property Wrappers")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct PropertyWrapperCard: View {
  let title: String
  let description: String
  let example: String
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8.h) {
      Text(title)
        .font(.scaledSystem(size: 16, weight: .semibold))
        .foregroundColor(.blue)
      
      Text(description)
        .font(.scaledSystem(size: 14))
        .foregroundColor(.secondary)
      
      Text(example)
        .font(.scaledSystem(size: 12, design: .monospaced))
        .foregroundColor(.green)
        .padding(.horizontal, 12.w)
        .padding(.vertical, 6.h)
        .background(
          RoundedRectangle(cornerRadius: 4.r)
            .fill(Color.green.opacity(0.1))
        )
    }
    .padding(16.w)
    .background(
      RoundedRectangle(cornerRadius: 12.r)
        .fill(Color(.secondarySystemBackground))
    )
  }
}

// MARK: - View Modifiers Demo

struct ViewModifiersDemo: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24.h) {
        Text("View Modifiers Demo")
          .font(.scaledSystem(size: 24, weight: .bold))
        
        // Responsive padding
        Text("Responsive Padding")
          .font(.scaledSystem(size: 16, weight: .medium))
          .padding(.horizontal, 20.w)
          .padding(.vertical, 8.w)
          .background(Color.blue.opacity(0.1))
          .responsiveCornerRadius(8)
        
        // Responsive frame
        Rectangle()
          .fill(Color.green)
          .responsiveFrame(width: 200, height: 100)
          .responsiveCornerRadius(12)
        
        // Custom responsive modifier
        Text("Custom Modifier")
          .font(.scaledSystem(size: 14))
          .responsiveCard()
        
        // Animated scaling
        AnimatedScalingExample()
        
        Spacer(minLength: 40.h)
      }
      .padding(.horizontal, 20.w)
    }
    .navigationTitle("View Modifiers")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct AnimatedScalingExample: View {
  @State private var isScaled = false
  
  var body: some View {
    VStack(spacing: 16.h) {
      Text("Animated Scaling")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      Circle()
        .fill(Color.purple)
        .frame(
          width: isScaled ? 100.w : 60.w,
          height: isScaled ? 100.h : 60.h
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isScaled)
      
      Button("Toggle Scale") {
        isScaled.toggle()
      }
      .font(.scaledSystem(size: 16, weight: .medium))
      .foregroundColor(.white)
      .padding(.horizontal, 24.w)
      .padding(.vertical, 12.h)
      .background(Color.purple)
      .responsiveCornerRadius(8)
    }
  }
}

// MARK: - Responsive Layout Demo

struct ResponsiveLayoutDemo: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24.h) {
        Text("Responsive Layout")
          .font(.scaledSystem(size: 24, weight: .bold))
        
        // Responsive grid
        ResponsiveGrid()
        
        // Adaptive stack
        AdaptiveStackExample()
        
        // Responsive spacing
        ResponsiveSpacingExample()
        
        Spacer(minLength: 40.h)
      }
      .padding(.horizontal, 20.w)
    }
    .navigationTitle("Responsive Layout")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct ResponsiveGrid: View {
  private let items = Array(1...12)
  private let columns = [
    GridItem(.flexible(), spacing: 8.w),
    GridItem(.flexible(), spacing: 8.w),
    GridItem(.flexible(), spacing: 8.w),
    GridItem(.flexible(), spacing: 8.w)
  ]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12.h) {
      Text("Responsive Grid")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      LazyVGrid(columns: columns, spacing: 8.h) {
        ForEach(items, id: \.self) { item in
          RoundedRectangle(cornerRadius: 6.r)
            .fill(Color.blue.opacity(0.7))
            .aspectRatio(1, contentMode: .fit)
            .overlay(
              Text("\(item)")
                .font(.scaledSystem(size: 14, weight: .bold))
                .foregroundColor(.white)
            )
        }
      }
    }
  }
}

struct AdaptiveStackExample: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12.h) {
      Text("Adaptive Stack")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      // This would adapt based on screen size in a real implementation
      HStack(spacing: 12.w) {
        ForEach(1...3, id: \.self) { index in
          VStack {
            Circle()
              .fill(Color.orange)
              .frame(width: 40.w, height: 40.h)
            
            Text("Item \(index)")
              .font(.scaledSystem(size: 12))
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16.h)
          .background(
            RoundedRectangle(cornerRadius: 8.r)
              .fill(Color.orange.opacity(0.1))
          )
        }
      }
    }
  }
}

struct ResponsiveSpacingExample: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 12.h) {
      Text("Responsive Spacing")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      VStack(spacing: 16.h) {
        ForEach(1...4, id: \.self) { index in
          HStack {
            Rectangle()
              .fill(Color.red)
              .frame(width: 4.w, height: 20.h)
            
            Text("Spacing example \(index)")
              .font(.scaledSystem(size: 14))
            
            Spacer()
          }
        }
      }
    }
  }
}

// MARK: - Performance Demo

struct PerformanceDemoView: View {
  @State private var isRunning = false
  @State private var results = ""
  
  var body: some View {
    VStack(spacing: 24.h) {
      Text("Performance Testing")
        .font(.scaledSystem(size: 24, weight: .bold))
      
      Button(action: runPerformanceTest) {
        Text(isRunning ? "Running..." : "Run Performance Test")
          .font(.scaledSystem(size: 16, weight: .medium))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .frame(height: 44.h)
          .background(
            RoundedRectangle(cornerRadius: 8.r)
              .fill(isRunning ? Color.gray : Color.blue)
          )
      }
      .disabled(isRunning)
      
      if !results.isEmpty {
        ScrollView {
          Text(results)
            .font(.scaledSystem(size: 12, design: .monospaced))
            .padding(16.w)
            .background(
              RoundedRectangle(cornerRadius: 8.r)
                .fill(Color.gray.opacity(0.1))
            )
        }
      }
      
      Spacer()
    }
    .padding(.horizontal, 20.w)
    .navigationTitle("Performance Test")
    .navigationBarTitleDisplayMode(.inline)
  }
  
  private func runPerformanceTest() {
    isRunning = true
    results = ""
    
    DispatchQueue.global(qos: .userInitiated).async {
      // Run performance benchmarks
      let startTime = CFAbsoluteTimeGetCurrent()
      
      // Test standard scaling
      let standardTest = measureTime {
        for _ in 0..<100000 {
          _ = 100.0.w
        }
      }
      
      // Test fast scaling
      let fastTest = measureTime {
        let fastScale = ScreenUtil.shared.fastScale
        for _ in 0..<100000 {
          _ = fastScale.width(100.0)
        }
      }
      
      // Test batch operations
      let batchTest = measureTime {
        let values = Array(1...1000)
        for _ in 0..<100 {
          _ = ScreenUtil.shared.batchWidths(values)
        }
      }
      
      let totalTime = CFAbsoluteTimeGetCurrent() - startTime
      
      DispatchQueue.main.async {
        results = """
                Performance Test Results:
                
                Standard Scaling: \(String(format: "%.3f", standardTest * 1000))ms
                Fast Scaling: \(String(format: "%.3f", fastTest * 1000))ms
                Batch Operations: \(String(format: "%.3f", batchTest * 1000))ms
                
                Total Test Time: \(String(format: "%.3f", totalTime))s
                
                Fast scaling is \(String(format: "%.1f", standardTest / fastTest))x faster
                """
        isRunning = false
      }
    }
  }
  
  private func measureTime<T>(_ operation: () -> T) -> TimeInterval {
    let startTime = CFAbsoluteTimeGetCurrent()
    _ = operation()
    return CFAbsoluteTimeGetCurrent() - startTime
  }
}

// MARK: - Custom Components Demo

struct CustomComponentsDemo: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24.h) {
        Text("Custom Components")
          .font(.scaledSystem(size: 24, weight: .bold))
        
        ResponsiveProfileCard()
        
        ResponsiveProgressBar()
        
        ResponsiveStatsView()
        
        Spacer(minLength: 40.h)
      }
      .padding(.horizontal, 20.w)
    }
    .navigationTitle("Custom Components")
    .navigationBarTitleDisplayMode(.inline)
  }
}

struct ResponsiveProfileCard: View {
  var body: some View {
    VStack(spacing: 16.h) {
      Text("Profile Card")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      HStack(spacing: 16.w) {
        Circle()
          .fill(
            LinearGradient(
              colors: [.blue, .purple],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 60.w, height: 60.h)
          .overlay(
            Text("JD")
              .font(.scaledSystem(size: 20, weight: .bold))
              .foregroundColor(.white)
          )
        
        VStack(alignment: .leading, spacing: 4.h) {
          Text("John Doe")
            .font(.scaledSystem(size: 16, weight: .semibold))
          
          Text("iOS Developer")
            .font(.scaledSystem(size: 14))
            .foregroundColor(.secondary)
          
          HStack(spacing: 4.w) {
            Image(systemName: "location.fill")
              .font(.system(size: 10.sp))
            Text("San Francisco, CA")
              .font(.scaledSystem(size: 12))
          }
          .foregroundColor(.secondary)
        }
        
        Spacer()
      }
      .padding(20.w)
      .background(
        RoundedRectangle(cornerRadius: 16.r)
          .fill(Color(.secondarySystemBackground))
          .shadow(color: .black.opacity(0.1), radius: 8.r, y: 4.h)
      )
    }
  }
}

struct ResponsiveProgressBar: View {
  @State private var progress: Double = 0.7
  
  var body: some View {
    VStack(spacing: 16.h) {
      Text("Progress Bar")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      VStack(alignment: .leading, spacing: 8.h) {
        HStack {
          Text("Project Progress")
            .font(.scaledSystem(size: 14, weight: .medium))
          
          Spacer()
          
          Text("\(Int(progress * 100))%")
            .font(.scaledSystem(size: 12, weight: .medium))
            .foregroundColor(.blue)
        }
        
        GeometryReader { geometry in
          ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4.r)
              .fill(Color.gray.opacity(0.2))
              .frame(height: 8.h)
            
            RoundedRectangle(cornerRadius: 4.r)
              .fill(
                LinearGradient(
                  colors: [.blue, .purple],
                  startPoint: .leading,
                  endPoint: .trailing
                )
              )
              .frame(width: geometry.size.width * progress, height: 8.h)
              .animation(.easeInOut(duration: 0.5), value: progress)
          }
        }
        .frame(height: 8.h)
      }
      .padding(16.w)
      .background(
        RoundedRectangle(cornerRadius: 12.r)
          .fill(Color(.secondarySystemBackground))
      )
      
      Button("Update Progress") {
        progress = Double.random(in: 0.3...1.0)
      }
      .font(.scaledSystem(size: 14, weight: .medium))
    }
  }
}

struct ResponsiveStatsView: View {
  let stats = [
    ("Projects", "24", Color.blue),
    ("Tasks", "156", Color.green),
    ("Hours", "1.2K", Color.orange),
    ("Reviews", "98%", Color.purple)
  ]
  
  var body: some View {
    VStack(spacing: 16.h) {
      Text("Statistics")
        .font(.scaledSystem(size: 18, weight: .semibold))
      
      LazyVGrid(columns: [
        GridItem(.flexible(), spacing: 8.w),
        GridItem(.flexible(), spacing: 8.w)
      ], spacing: 12.h) {
        ForEach(stats.indices, id: \.self) { index in
          let (title, value, color) = stats[index]
          
          VStack(spacing: 8.h) {
            Text(value)
              .font(.scaledSystem(size: 24, weight: .bold))
              .foregroundColor(color)
            
            Text(title)
              .font(.scaledSystem(size: 12))
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20.h)
          .background(
            RoundedRectangle(cornerRadius: 12.r)
              .fill(color.opacity(0.1))
          )
        }
      }
    }
  }
}

// MARK: - Custom View Modifiers

extension View {
  func responsiveCard() -> some View {
    self
      .padding(.horizontal, 16.w)
      .padding(.vertical, 12.h)
      .background(
        RoundedRectangle(cornerRadius: 8.r)
          .fill(Color(.secondarySystemBackground))
          .shadow(color: .black.opacity(0.1), radius: 4.r, y: 2.h)
      )
  }
}

// MARK: - App Entry Point
struct ScreenUtilExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  var body: some View {
    TabView {
      BasicSwiftUIView()
        .tabItem {
          Image(systemName: "house")
          Text("Basic")
        }
      
      AdvancedSwiftUIView()
        .tabItem {
          Image(systemName: "gear")
          Text("Advanced")
        }
    }
  }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .previewDevice("iPhone 14 Pro")
  }
}
