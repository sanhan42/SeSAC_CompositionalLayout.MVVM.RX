//
//  CObservable.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/20.
//

import Foundation

// MVVM 패턴을 실습하기 위해, 양방향 바인딩이 가능한 객체를 만들기 위함.
class CObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}
