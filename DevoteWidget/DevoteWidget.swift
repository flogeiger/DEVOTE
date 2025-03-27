//
//  DevoteWidget.swift
//  DevoteWidget
//
//  Created by Florian Geiger on 26.03.25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct DevoteWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var fontStyle: Font{
        if widgetFamily == .systemSmall{
            return .system(.footnote,design: .rounded)
        }
        else{
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                backgroundGradient
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36,
                        height: widgetFamily != .systemSmall ? 56 : 36)
                    .offset(
                        x: (geometry.size.width / 2) - 20,
                        y: (geometry.size.height / -2) + 20
                    )
                    .padding(.top, widgetFamily != .systemSmall ? 32 : 12)
                    .padding(.trailing, widgetFamily != .systemSmall ? 32 : 12)
                
                HStack {
                    Text("Just Do It")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(
                            Color(red: 0, green: 0, blue: 0, opacity: 0.5).blendMode(.overlay)
                        )
                        .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall{
                        Spacer()
                    }
                }
                .padding()
                .offset( y: (geometry.size.height / 2) - 24)
            }
        }
    }
}

struct DevoteWidget: Widget {
    let kind: String = "DevoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DevoteWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DevoteWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DevoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date(), emoji: "😀"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date(), emoji: "😀"))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date(), emoji: "😀"))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}


