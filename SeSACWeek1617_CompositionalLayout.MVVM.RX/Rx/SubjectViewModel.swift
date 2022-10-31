//
//  SubjectViewModel.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/25.
//

import Foundation
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    var contactData = [
        Contact(name: "Sanhan", age: 31, number: "01012341234"),
        Contact(name: "Jack", age: 23, number: "01022222222"),
        Contact(name: "MetaJack", age: 25, number: "01056785678")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func addNewData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...40), number: "")
        contactData.append(new)
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
        let result = query == "" ? contactData : contactData.filter { contact in
            contact.name.contains(query)
        }
        list.onNext(result)
    }
}
