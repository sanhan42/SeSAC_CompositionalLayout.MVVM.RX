//
//  RxCocoaExakmpleViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxCocoaExakmpleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Sanhan")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
        nickname.bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            nickname = "Hello"
        }
    }
    
    func setOperator() {
        
        Observable.repeatElement("Jack")
            .take(5) // Finite Observable Sequence
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        let intervalObservable =
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            //.disposed(by: disposeBag)
            // DisposeBag: 리소스 해제 관리 -
                // 1. 시퀀스 끝날 때 (bind 아닌 상황. complete, error)
                // 2. class deinit이 실행되면 자동 해제
                    // viewController가 deinit 되면, disposed도 알아서 동작. (cf. 순환 참조로 인해 deinit이 호출 안되는 상황 주의!)
                    // 만약, rootViewController 안이라면, deinit이 호출되지 않기 때문에, 직접 관리해줘야 한다. (3, 4번)
                // 3. dispose를 직접 호출. -> 구독하는 것 마다 별도로 관리. // .dispose()
                // 4. DisposeBag을 새롭게 할당하거나, nil 전달.
                    // -> observable을 하나씩 수동으로 dispose 해주기가 어렵기에, DisposeBag을 새롭게 할당해줌으로 기존에 연결되어있던 관계들을 한번에 끊어줌.
        let intervalObservable2 =
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            intervalObservable.dispose() // 구독하는 것 마다 별도로 관리!
//            intervalObservable2.dispose()
            self.disposeBag = DisposeBag() // 한번에 리소스를 정리
        }
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)

        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func setSign() {
        // ex. 텍스트필드 1(Observable), 텍스트필드 2(Observable) => 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return " Name\t:\t\(value1) 이고,\n 이메일\t:\t\(value2) 입니다."
        }.bind(to: simpleLabel.rx.text).disposed(by: disposeBag)
        
        signName // UITextField
            .rx // Reactive
            .text // String?
            .orEmpty // Strig
            .map { $0.count < 4 } // Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.showAlert()
            })
            .disposed(by: disposeBag)
//            .subscribe { [weak self] _ in
//                self?.showAlert()
//            }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false)//just(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
            
        simpleTableView.rx.modelSelected(String.self).map { data in
            "\(data)을 클릭했습니다."
        }.bind(to: simpleLabel.rx.text).disposed(by: disposeBag)

    }
    
    func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self).map({ $0.description})
            .bind(to: simpleLabel.rx.text)
//        .subscribe (onNext: { value in
//            print(value)
//        })
        .disposed(by: disposeBag)
    }
}
