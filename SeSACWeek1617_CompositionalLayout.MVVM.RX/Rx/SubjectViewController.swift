//
//  SubjectViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태.
    let behavior = BehaviorSubject(value: 100) // 초깃값 필수.
    let replay = ReplaySubject<Int>.create(bufferSize: 3) // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let asyncSub = AsyncSubject<Int>()
    // VariableSubject 지금은 사용하지 않는 것.
    
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        publichSubject()
        //        behaviorSubject()
        //        replaySubject()
        //        asyncSubject()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        restoreButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.addNewData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
//            .distinctUntilChanged() // 같은 값을 받지 않음
            .subscribe { vc, value in                print("============", value)
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
    }
}

extension SubjectViewController {
    func asyncSubject() {
        // complete 전 마지막 값
        asyncSub.onNext(1)
        asyncSub.onNext(2)
        
        asyncSub.subscribe { value in
            print("async - \(value)")
        } onError: { error in
            print("async - \(error)")
        } onCompleted: {
            print("async completed")
        } onDisposed: {
            print("async disposed")
        }
        .disposed(by: disposeBag)
        
        asyncSub.onNext(3)
        asyncSub.onNext(4)
        asyncSub.on(.next(5))
        asyncSub.onCompleted()
        
        asyncSub.onNext(6)
    }
    
    func replaySubject() {
        // BufferSize는 메모리를 차지함. -> 메모리 부하를 주의!
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        
        replay.subscribe { value in
            print("replay - \(value)")
        } onError: { error in
            print("replay - \(error)")
        } onCompleted: {
            print("replay completed")
        } onDisposed: {
            print("replay disposed")
        }
        .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5))
        replay.onCompleted()
        
        replay.onNext(6)
    }
    
    func behaviorSubject() {
        // 구독 전의 가장 최근 값을 같이 emit해준다.
        behavior.onNext(1)
        behavior.onNext(2)
        
        behavior.subscribe { value in
            print("behavior - \(value)")
        } onError: { error in
            print("behavior - \(error)")
        } onCompleted: {
            print("behavior completed")
        } onDisposed: {
            print("behavior disposed")
        }
        .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        behavior.onCompleted()
        
        behavior.onNext(6)
    }
    
    func publichSubject() {
        // subscribe 전 || (error || completed notification 이휴) 이벤트 무시
        // subscripe 후에 대한 이벤트는 다 처리
        publish.onNext(1)
        publish.onNext(2)
        
        publish.subscribe { value in
            print("publish - \(value)")
        } onError: { error in
            print("publish - \(error)")
        } onCompleted: {
            print("publish completed")
        } onDisposed: {
            print("publish disposed")
        }
        .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        publish.onCompleted()
        
        publish.onNext(6)
    }
}
