//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Liko Setiawan on 17/04/24.
//

import Foundation

extension EditView{
    @Observable
    class ViewModel{
        enum LoadingState {
            case loading, loaded, failed
        }
        
        var pages = [Page]()
        var location: Location
        var name: String
        var description: String
        
        init(location: Location) {
            name = location.name
            description = location.description
            self.location = location
            
        }
        
        var loadingState = LoadingState.loading
        
        func createNewLocation() -> Location{
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
        func fetchNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else { return }
            
            do{
                let (data, _ ) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
