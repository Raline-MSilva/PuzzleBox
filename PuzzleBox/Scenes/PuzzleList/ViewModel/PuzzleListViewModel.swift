//
//  PuzzleListViewModel.swift
//  PuzzleBox
//
//  Created by Raline Maria da Silva on 15/06/25.
//

import UIKit

protocol PuzzleListViewModelProtocol {
    var allPuzzles: [PuzzleListItem] { get }
    var filteredPuzzles: [PuzzleListItem] { get }
    var currentStatus: PuzzleStatus { get set}
    var currentType: PuzzleType { get set }
    
    func filterPuzzles(status: PuzzleStatus, type: PuzzleType)
    func countForStatus(_ status: PuzzleStatus) -> Int
    func puzzle(at index: Int) -> PuzzleListItem
    func countByStatus(for type: PuzzleType) -> [PuzzleStatus: Int]
    func countByType() -> [PuzzleType: Int]
}

protocol PuzzleListViewModelDelegate: AnyObject {
    func didUpdateFilteredPuzzles()
}

final class PuzzleListViewModel: PuzzleListViewModelProtocol {
    // MARK: - Properties
    
    private(set) var allPuzzles: [PuzzleListItem] = []
    private(set) var filteredPuzzles: [PuzzleListItem] = []
    
    internal var currentStatus: PuzzleStatus = .completed
    internal var currentType: PuzzleType = .owned
    
    var numberOfFilteredPuzzles: Int {
            return filteredPuzzles.count
        }
    weak var delegate: PuzzleListViewModelDelegate?
    
    // MARK: - Init
    
    init() {
        loadMockData()
        filterPuzzles(status: .completed, type: .owned)
    }

    func filterPuzzles(status: PuzzleStatus, type: PuzzleType) {
        currentStatus = status
        currentType = type

        filteredPuzzles = allPuzzles.filter { $0.status == status && $0.type == type }
 
        delegate?.didUpdateFilteredPuzzles()
    }

    func countForStatus(_ status: PuzzleStatus) -> Int {
        return allPuzzles.filter { $0.status == status }.count
    }
    
    func countByStatus(for type: PuzzleType) -> [PuzzleStatus: Int] {
        return PuzzleStatus.allCases.reduce(into: [:]) { result, status in
            result[status] = allPuzzles.filter { $0.status == status && $0.type == type }.count
        }
    }
    
    func countByType() -> [PuzzleType: Int] {
        return PuzzleType.allCases.reduce(into: [:]) { result, type in
            result[type] = allPuzzles.filter { $0.type == type }.count
        }
    }

    func puzzle(at index: Int) -> PuzzleListItem {
        return filteredPuzzles[index]
    }

    // MARK: - Mock Data
    
    private func loadMockData() {
        allPuzzles = [
            PuzzleListItem(id: UUID(), name: "Vintage Library", brand: "Ravensburger", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?vintage,library", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Autumn Cottage", brand: "Falcon", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?cottage,autumn", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "World Map", brand: "Clementoni", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?map,world", status: .inProgress, type: .owned),
            PuzzleListItem(id: UUID(), name: "Paris Street Scene", brand: "Trefl", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?paris,street", status: .notStarted, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Sunset at the Lake", brand: "Educa", pieces: 500, imageURL: "https://source.unsplash.com/featured/?sunset,lake", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Winter Forest", brand: "Castorland", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?winter,forest", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "Japanese Garden", brand: "Ravensburger", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?japan,garden", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Hot Air Balloons", brand: "Clementoni", pieces: 750, imageURL: "https://source.unsplash.com/featured/?hot-air-balloon", status: .inProgress, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Cat in the Window", brand: "Falcon", pieces: 500, imageURL: "https://source.unsplash.com/featured/?cat,window", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "Tropical Beach", brand: "Trefl", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?beach,tropical", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "New York Skyline", brand: "Educa", pieces: 2000, imageURL: "https://source.unsplash.com/featured/?newyork,skyline", status: .inProgress, type: .owned),
            PuzzleListItem(id: UUID(), name: "Colorful Market", brand: "Castorland", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?market,colorful", status: .notStarted, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Underwater World", brand: "Clementoni", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?underwater,fish", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Old Street in Italy", brand: "Falcon", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?italy,street", status: .notStarted, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Desert Sunset", brand: "Trefl", pieces: 750, imageURL: "https://source.unsplash.com/featured/?desert,sunset", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Mountain Lake", brand: "Ravensburger", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?mountain,lake", status: .inProgress, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Forest Path", brand: "Educa", pieces: 500, imageURL: "https://source.unsplash.com/featured/?forest,path", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "Sunflower Field", brand: "Castorland", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?sunflower,field", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Eiffel Tower View", brand: "Clementoni", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?eiffel,tower", status: .inProgress, type: .owned),
            PuzzleListItem(id: UUID(), name: "Butterfly Garden", brand: "Trefl", pieces: 750, imageURL: "https://source.unsplash.com/featured/?butterfly,garden", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "Antique Cars", brand: "Ravensburger", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?vintage,cars", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Cabin in the Woods", brand: "Educa", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?cabin,woods", status: .inProgress, type: .owned),
            PuzzleListItem(id: UUID(), name: "Village Life", brand: "Falcon", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?village", status: .notStarted, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Birds on a Branch", brand: "Trefl", pieces: 500, imageURL: "https://source.unsplash.com/featured/?birds,branch", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Lighthouse by the Sea", brand: "Clementoni", pieces: 750, imageURL: "https://source.unsplash.com/featured/?lighthouse,sea", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "City Café", brand: "Castorland", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?city,cafe", status: .inProgress, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Snowy Mountains", brand: "Educa", pieces: 2000, imageURL: "https://source.unsplash.com/featured/?snow,mountains", status: .completed, type: .traveler),
            PuzzleListItem(id: UUID(), name: "Tuscany Landscape", brand: "Ravensburger", pieces: 1500, imageURL: "https://source.unsplash.com/featured/?tuscany,landscape", status: .notStarted, type: .owned),
            PuzzleListItem(id: UUID(), name: "Color Explosion", brand: "Falcon", pieces: 500, imageURL: "https://source.unsplash.com/featured/?abstract,colors", status: .completed, type: .owned),
            PuzzleListItem(id: UUID(), name: "Rainy Street", brand: "Trefl", pieces: 1000, imageURL: "https://source.unsplash.com/featured/?rain,street", status: .inProgress, type: .traveler)
        ]
    }
}
