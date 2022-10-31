//
//  NewsViewModel.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    
//    var pageNumber: CObservable<String> = CObservable("3,000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
//    var newsList: CObservable<[News.NewsItem]> = CObservable(News.items)
//    var newsList = BehaviorSubject(value: News.items)
    var newsList = BehaviorRelay(value: News.items)
    
    func changePageNumberFormat(text: String) {
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let result = numberFormatter.string(for: number)!
        pageNumber.onNext(result)
    }
    
    func resetNewsList() {
//        newsList.value = result
//        newsList.onNext([]
        newsList.accept([])
    }
    
    func loadNewsList() {
//        newsList.onNext(News.items)
        newsList.accept(News.items)
    }
}
