//
//  ScalingShowcaseTests.swift
//  ScreenUtil Examples
//
//  Exercises the bulk + per-call geometry scaling APIs that the demo claims to
//  showcase. Previously these lived as a contrived `selfTest()` row inside the
//  Device cards; proving coverage in a test keeps the views focused on rendering.
//  Created by Dicky Darmawan on 27/06/26.
//

import ScreenUtil
import UIKit
import XCTest

final class ScalingShowcaseTests: XCTestCase {
    func testBatchScalerCoversEveryBulkEntryPoint() {
        let batch = ScreenUtil.shared.batchScaler
        XCTAssertEqual(batch.widths([10, 20, 30]).count, 3)
        XCTAssertEqual(batch.heights([10, 20]).count, 2)
        XCTAssertEqual(batch.fontSizes([12, 14]).count, 2)
        XCTAssertEqual(batch.radii([8, 12]).count, 2)
        XCTAssertEqual(batch.sizes([CGSize(width: 10, height: 10)]).count, 1)
        XCTAssertEqual(batch.points([CGPoint(x: 10, y: 10), CGPoint(x: 20, y: 20)]).count, 2)
        XCTAssertEqual(batch.rects([CGRect(x: 0, y: 0, width: 50, height: 50)]).count, 1)
        XCTAssertEqual(batch.scale([100, 200], scaleType: .height).count, 2)
        XCTAssertEqual(batch.edgeInsets([UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)]).count, 1)
    }

    func testFastScaleAndGeometryHelpersAreCallable() {
        let fast = ScreenUtil.shared.fastScale
        _ = fast.size(CGSize(width: 10, height: 10))
        _ = fast.point(CGPoint(x: 5, y: 5))
        _ = fast.rect(CGRect(x: 0, y: 0, width: 8, height: 8))
        XCTAssertGreaterThan(withFastScale { $0.width(20) }, 0)

        _ = CGSize.scaled(width: 8, height: 8)
        _ = CGSize(width: 8, height: 8).fastScaled()
        _ = CGRect.scaled(x: 0, y: 0, width: 10, height: 10)
        _ = CGRect.responsive(x: 0, y: 0, width: 10, height: 10)
        _ = CGPoint.responsive(x: 4, y: 4)
        _ = CGPoint(x: 4, y: 4).fastScaled()

        XCTAssertNotNil(UIFont.customFont(name: "Menlo", size: 12, scaled: true))
    }
}
