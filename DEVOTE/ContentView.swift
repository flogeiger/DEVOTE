//
//  ContentView.swift
//  DEVOTE
//
//  Created by Florian Geiger on 18.03.25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    ) private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // MARK: - HEADER
                    HStack(spacing: 10) {
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule().stroke(Color.white, lineWidth: 2)
                            )
                        
                        Button(action: {
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" :  "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })
                    }
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    // MARK: - NEW TASK BUTTON
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 30, weight: .semibold, design: .rounded))
                            Text("New Task")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                        }
                    })
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0.0, y: 4.0)
                    
                    // MARK: - TASKS
                    List {
                        ForEach(items) { item in
                            Toggle(isOn: Binding(
                                get: { item.completion ?? false },
                                set: { newValue in item.completion = newValue }
                            )) {
                                Text(item.task ?? "")
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.heavy)
                                    .foregroundColor((item.completion ?? false) ? Color.pink : Color.primary)
                                    .padding(.vertical, 12)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color.black.opacity(0.3), radius: 12)
                    .frame(maxWidth: 640)
                }
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .animation(.easeOut(duration: 0.5), value: showNewTaskItem)
            }
            .onAppear {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .navigationBarHidden(true)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
