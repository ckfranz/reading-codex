//
//  MapView.swift
//  WOT Characters
//
//  Created by Curtis Franz on 2024-12-28.
//
import SwiftUI

struct MapView: View {
    let mapImage: String = "map" // The name of your map image file in the assets
    @Binding var isUIHidden: Bool // Bind this to the parent view's state

    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    @State private var initialScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let mapSize = CGSize(
                    width: geometry.size.width * scale,
                    height: geometry.size.height * scale
                )
                
                Image(mapImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = applyResistance(
                                    to: CGSize(
                                        width: initialOffset.width + value.translation.width,
                                        height: initialOffset.height + value.translation.height
                                    ),
                                    mapSize: mapSize,
                                    screenSize: geometry.size
                                )
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                                    offset = clampOffset(offset, mapSize: mapSize, screenSize: geometry.size)
                                }
                                initialOffset = offset
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                scale = applyZoomResistance(initialScale * value, minScale: 1.0, maxScale: 5.0)
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4)) {
                                    scale = clampScale(scale, minScale: 1.0, maxScale: 15.0)
                                    offset = clampOffset(offset, mapSize: mapSize, screenSize: geometry.size)
                                }
                                initialScale = scale
                            }
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .onTapGesture {
                        isUIHidden.toggle() // Toggle UI visibility
                    }
            }
            
            // Credits text overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Map Artist: Dimension Door Maps")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                        .onTapGesture {
                            if let url = URL(string: "https://linktr.ee/dimensiondoormaps") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .padding()
            }
        }
        .navigationBarHidden(isUIHidden) // Hide the navigation bar when UI is hidden
        .statusBar(hidden: isUIHidden) // Hide the status bar if UI is hidden
        .edgesIgnoringSafeArea(isUIHidden ? .all : []) // Ignore safe area when UI is hidden
    }
}

    // Resistance functions...
    private func applyResistance(to offset: CGSize, mapSize: CGSize, screenSize: CGSize) -> CGSize {
        let maxOffsetX = max(0, (mapSize.width - screenSize.width) / 2)
        let maxOffsetY = max(0, (mapSize.height - screenSize.height) / 2)

        func resistance(value: CGFloat, limit: CGFloat) -> CGFloat {
            if abs(value) <= limit {
                return value
            } else {
                let excess = abs(value) - limit
                return limit * (value < 0 ? -1 : 1) + excess / 2
            }
        }

        return CGSize(
            width: resistance(value: offset.width, limit: maxOffsetX),
            height: resistance(value: offset.height, limit: maxOffsetY)
        )
    }

    private func applyZoomResistance(_ scale: CGFloat, minScale: CGFloat, maxScale: CGFloat) -> CGFloat {
        if scale < minScale {
            return minScale - (minScale - scale) / 2
        } else if scale > maxScale {
            return maxScale + (scale - maxScale) / 2
        } else {
            return scale
        }
    }

    private func clampScale(_ scale: CGFloat, minScale: CGFloat, maxScale: CGFloat) -> CGFloat {
        return min(max(scale, minScale), maxScale)
    }

    private func clampOffset(_ offset: CGSize, mapSize: CGSize, screenSize: CGSize) -> CGSize {
        let maxOffsetX = max(0, (mapSize.width - screenSize.width) / 2)
        let maxOffsetY = max(0, (mapSize.height - screenSize.height) / 2)

        return CGSize(
            width: min(max(offset.width, -maxOffsetX), maxOffsetX),
            height: min(max(offset.height, -maxOffsetY), maxOffsetY)
        )
    }

