//
//  LeanScaleTaskTests.swift
//  LeanScaleTaskTests
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import XCTest
@testable import LeanScaleTask

class LeanScaleTaskTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddFav() throws {
        UserDefaults.standard.removeObject(forKey: "favourite-games")
        let gameVM = GameVM(game: Game(id: 1, name: "Test Game", slug: "Test Game", backgroundImage: "", metacritic: 88, genres: [], description: "", redditUrl: "", website: ""))
        gameVM.addToFavourite()
        let listVM = GameListVM()
        listVM.getFavouriteGames()
        XCTAssert(listVM.games.contains(where: {$0.id == gameVM.id}))
        UserDefaults.standard.removeObject(forKey: "favourite-games")
    }
    
    func testRemoveFav() throws {
        UserDefaults.standard.removeObject(forKey: "favourite-games")
        let gameVM = GameVM(game: Game(id: 1, name: "Test Game", slug: "Test Game", backgroundImage: "", metacritic: 88, genres: [], description: "", redditUrl: "", website: ""))
        gameVM.addToFavourite()
        let listVM = GameListVM()
        listVM.getFavouriteGames()
        XCTAssert(listVM.games.contains(where: {$0.id == gameVM.id}))
        gameVM.removeFromFavourite()
        listVM.getFavouriteGames()
        XCTAssert(!listVM.games.contains(where: {$0.id == gameVM.id}))
        UserDefaults.standard.removeObject(forKey: "favourite-games")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
