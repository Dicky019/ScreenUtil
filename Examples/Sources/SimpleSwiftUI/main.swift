//
//  SimpleSwiftUI.swift
//  ScreenUtil Examples
//
//  A minimal SwiftUI example demonstrating identical UI to the UIKit version.
//
import SwiftUI
import ScreenUtil

struct SimpleSwiftUIView: View {
  @State private var count = 0

  var body: some View {
    VStack(spacing: 24.h) {
      Text("Count: \(count)")
        .font(.scaledSystem(size: 24, weight: .bold))

      Button("Increment") {
        count += 1
      }
      .font(.scaledSystem(size: 16, weight: .medium))
      .padding(.horizontal, 24.w)
      .padding(.vertical, 12.h)
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8.r)
    }
    .padding(20.w)
    .onAppear {
      ScreenUtil.shared.configure(with: .iPhone13Pro)
    }
  }
}

@main
struct SimpleSwiftUIApp: App {
  var body: some Scene {
    WindowGroup {
      SimpleSwiftUIView()
    }
  }
}
