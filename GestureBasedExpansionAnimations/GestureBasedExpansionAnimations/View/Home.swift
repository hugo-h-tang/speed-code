//
//  Home.swift
//  GestureBasedExpansionAnimations
//
//  Created by Hugo L on 2022/8/2.
//
// Difficulties：
// - Calculate the rect of the image, and the image where the drag gesture is located
//     - local coordinateSpace
//     - PreferenceKey
//
// - Animation
//     ```
//       withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
//          activeTool = tools[index]
//       }
//     ```

import SwiftUI

struct Home: View {
    @State var tools: [Tool] = [
        .init(icon: "scribble.variable", name: "Scribble", color: .purple),
        .init(icon: "lasso", name: "Lasso", color: .green),
        .init(icon: "plus.bubble", name: "Comment", color: .blue),
        .init(icon: "bubble.left.and.bubble.right.fill", name: "Enhance", color: .orange),
        .init(icon: "paintbrush.pointed.fill", name: "Picker", color: .pink),
        .init(icon: "rotate.3d", name: "Rotate", color: .indigo),
        .init(icon: "gear.badge.questionmark", name: "Settings", color: .yellow),
    ]
    // MARK: animation property
    @State var activeTool: Tool?
    var statedPosition: CGRect? = .zero
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                ForEach($tools) { $tool in
                    ToolView(tool: $tool)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black, radius: 10, x: 5, y: 5)
                    .opacity(0.1)
                    .frame(width: 65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .coordinateSpace(name: "AREA")
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        var location = value.location
                        if let first = tools.first {
                            location.x = first.toolPosition.midX
                        }
                        if let index = tools.firstIndex(where: { tool in
                            tool.toolPosition.contains(location)
                        }), activeTool?.id != tools[index].id {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                                activeTool = tools[index]
                            }
                        }
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)) {
                            activeTool = nil
                        }
                    })
            )
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    func ToolView(tool: Binding<Tool>) -> some View {
        HStack(spacing: 5) {
            Image(systemName: tool.wrappedValue.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .padding(.leading, activeTool?.id == tool.id ? 5 : 0)
                .background(
                    GeometryReader { proxy in
                        let frame = proxy.frame(in: .named("AREA"))
                        Color.clear
                            .preference(key: RectKey.self, value: frame)
                            .onPreferenceChange(RectKey.self) { rect in
                                tool.wrappedValue.toolPosition = rect
                            }
                    }
                )
            
            if activeTool?.id == tool.id {
                Text(tool.wrappedValue.name)
                    .padding(.trailing, 15)
                    .foregroundColor(.white)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(tool.wrappedValue.color)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
