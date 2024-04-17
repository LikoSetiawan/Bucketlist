//
//  EditView.swift
//  BucketList
//
//  Created by Liko Setiawan on 17/04/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby..."){
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading")
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Failed")
                    }
                }
            }
            .navigationTitle("place details")
            .toolbar {
                Button("Save"){
                    let newLocation = viewModel.createNewLocation()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
  
}

#Preview {
    EditView(location: .example){ _ in }
}



