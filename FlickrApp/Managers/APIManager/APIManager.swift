//
//  APIManager.swift
//  FlickrApp
//
//  Created by Tomashchik Daniil on 23/01/2022.
//

import Foundation
import UIKit

final class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    public func fetchData(completion: @escaping (Result<[FeedModel], Error>) -> Void ) {
        guard let url = Constants.url else {
            return
        }
        var resultArray = [FeedModel]()
        var request = URLRequest(url: url)
        request.httpMethod = Constants.httpMethod
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do {
                if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary  {
                    if let items = result.value(forKey: Constants.itemsKey) as? NSArray {
                        for element in items {
                            guard let itemDictionary = element as? NSDictionary else{
                                return
                            }
                            
                            let feed = FeedModel(title: itemDictionary.value(forKey: Constants.titleKey) as! String, link: itemDictionary.value(forKey: Constants.linkKey) as! String, media: itemDictionary.value(forKeyPath: Constants.imagePath) as! String)
                            
                            resultArray.append(feed)
                        }
                    }
                }
                completion(.success(resultArray))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

private extension APIManager {
    //MARK: - Constants
    struct Constants {
        static let httpMethod = "GET"
        static let itemsKey = "items"
        static let imagePath = "media.m"
        static let linkKey = "link"
        static let titleKey = "title"
        static let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=gardenning&tagmode=any&format=json&nojsoncallback=1")
    }
}
