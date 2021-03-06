//
//  ViewControllerVM.swift
//  FlickrApp
//
//  Created by Tomashchik Daniil on 23/01/2022.
//

import Foundation

final class FeedVM {
    //MARK: - Internal properties
    var dataModel = [FeedModel]()
    var loadData: ((State)->Void)?
}

extension FeedVM {
    enum State {
        case dataSetup(Bool)
    }
}

extension FeedVM {
    //MARK: - Public methods
    func launch() {
        APIManager.shared.fetchData {[weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case.success(let model):
                self.dataModel = model
                self.loadData?(.dataSetup(true))
                
            case .failure(_):
                break
            }
        }
    }
}
