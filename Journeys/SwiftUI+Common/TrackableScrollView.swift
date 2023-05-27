//
//  TrackableScrollView.swift
//  DrPillman
//
//  Created by Ilya Murashko on 13.11.2022.
//

import Foundation
import SwiftUI

// MARK: - TrackableScrollView

public struct TrackableScrollView<Content>: View where Content: View {
    private let axes: Axis.Set
    private let showIndicators: Bool
    @Binding private var contentOffset: CGFloat
    private let content: Content

    public init(_ axes: Axis.Set = .vertical, showIndicators: Bool = true, contentOffset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        _contentOffset = contentOffset
        self.content = content()
    }

    public var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: [self.calculateContentOffset(fromOutsideProxy: outsideProxy, insideProxy: insideProxy)])
                    }
                    VStack {
                        self.content
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[0]
            }
        }
    }

    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}

// MARK: - ScrollOffsetPreferenceKey

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
