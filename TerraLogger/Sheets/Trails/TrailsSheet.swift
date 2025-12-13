//
//  TrailsSheet.swift
//  TerraLogger
//
//  Created by Seb Martin on 2024-07-30.
//
import os
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

private enum TrailsNavDestination: Hashable {
    case recordTrail
    case importTrail([PersistentIdentifier])
}

let trailFileTypes = [ "gpx", "kml", "kmz", "geojson", "json"].compactMap {
    UTType(filenameExtension: $0)
}

struct TrailsSheet: View {
    @State private var navPath = NavigationPath()
    @State private var importFile = false
    @State private var searchText = ""
    
    @Environment(\.dismiss) private var dismissSheet
    
    @Environment(\.modelContext) private var modelContext
    var trails: [Trail]
    
    var filteredTrails: [Trail] {
        get {
            trails.filter {
                searchText.count == 0 || $0.name.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                ForEach(filteredTrails) { trail in
                    NavigationLink(value: trail) {
                        HStack {
                            Text(trail.name)
                            if !trail.visible {
                                Spacer()
                                Image(systemName: "eye.slash")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: handleDeleteTrail(at:))
            }
            .toolbar {
                if trails.count > 0 {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath")
                        Text("Trails").font(.headline)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu(content: {
                        // TODO: disable if already recording ... use environment?
                        Button(action: handleRecordTrail) { Text("Record with GPS"); Image(systemName: "location.north.line") }
                        Button(action: {
                            importFile = true
                        }) {
                            Text("Import"); Image(systemName: "square.and.arrow.down")
                        }
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Trails")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Trail.self) { trail in
                TrailDetails(trail: trail)
            }
            .navigationDestination(for: TrailsNavDestination.self) { destination in
                switch (destination) {
                case .recordTrail:
                    RecordTrailView(trailName: "New Trail")
                case .importTrail(let identifiers):
                    let trailsResult = try? modelContext.fetch(
                        FetchDescriptor<Trail>(
                            predicate: #Predicate<Trail> {
                                identifiers.contains($0.persistentModelID)
                            })
                        , batchSize: 25
                    )
                    let trails = trailsResult!.map { $0 }
                    ImportTrailView(trails: trails)
                }
            }
            .fileImporter(isPresented: $importFile, allowedContentTypes: trailFileTypes, onCompletion: handleImportTrail(result:))
        }
        .environment(\.dismissSheet, dismissSheet)
    }
    
    // - MARK: Trails
    
    func handleRecordTrail() {
        navPath.append(TrailsNavDestination.recordTrail)
    }
    
    
    func handleImportTrail(result: Result<URL, any Error>) {
        switch result {
        case .success(let url):
            // TODO: Show activity indicator
            
            @MainActor func handleImportedTrails(identifiers: [PersistentIdentifier]) {
                if identifiers.count == 1, let identifier = identifiers.first {
                    // There's only one so assume it's wanted and flag it as presentable
                    if let trail = modelContext.model(for: identifier) as? Trail {
                        trail.status = .complete
                        try? modelContext.save()
                        navPath.append(trail)
                    }
                }
                else if identifiers.count > 1 {
                    navPath.append(TrailsNavDestination.importTrail(identifiers))
                } else {
                    // TODO: notify the user that no trail was found
                }
            }
            
            let container = modelContext.container
            Task.detached {
                NSLog("url: ", url.absoluteString)
                let importer = Importer(modelContainer: container)
                let trailIdentifiers = await importer.importTrails(from: url)
                await handleImportedTrails(identifiers: trailIdentifiers)
            }
        case .failure(let error):
            Logger.main.error("Failed to obtain a valid trail file URL to import from, error: \(error)")
        }
    }

    func handleDeleteTrail(at offsets: IndexSet) {
        do {
            let trailIds = offsets.map {
                filteredTrails[$0].persistentModelID
            }
            try modelContext.delete(model: Trail.self, where: #Predicate {
                trailIds.contains($0.persistentModelID)
            })
            try modelContext.save()
        } catch let error {
            Logger.main.error("Failed to delete trail(s) with error: \(error)")
        }
    }
}

#Preview {
    @Previewable @State var show = true
    let trails: [Trail] = []
    
    MapButton("point.bottomleft.forward.to.arrow.triangle.scurvepath") {
        show = true
    }
        .sheet(isPresented: $show) {
            NavigationView {
                TrailsSheet(trails: trails)
            }
        }
}
