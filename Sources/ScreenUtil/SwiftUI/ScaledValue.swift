//
//  ScaledValue.swift
//  ScreenUtil
//
//  SwiftUI property wrappers for responsive values
//  Created by Dicky Darmawan on 06/06/26.
//

#if canImport(SwiftUI)
import SwiftUI

/// Property wrapper for a design value scaled to the device.
@propertyWrapper
public struct ScaledValue {
    private let value: CGFloat
    private let type: ScaleType

    public init(wrappedValue: CGFloat, _ type: ScaleType = .width) {
        self.value = wrappedValue
        self.type = type
    }

    public var wrappedValue: CGFloat {
        switch type {
        case .width:  return value.w
        case .height: return value.h
        case .text:   return value.sp
        case .radius: return value.r
        }
    }
}

/// Property wrapper for a percentage of a screen dimension.
@propertyWrapper
public struct ScreenPercentage {
    private let percentage: CGFloat
    private let dimension: Dimension

    public enum Dimension {
        case width
        case height
    }

    public init(wrappedValue: CGFloat, _ dimension: Dimension) {
        self.percentage = wrappedValue
        self.dimension = dimension
    }

    public var wrappedValue: CGFloat {
        switch dimension {
        case .width:
            return percentage.sw
        case .height:
            return percentage.sh
        }
    }
}

#endif
