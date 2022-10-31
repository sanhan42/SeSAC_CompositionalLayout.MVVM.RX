//
//  ValidationViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
//        observableVSSubject()
    }

    func bind() {
        // Stream == Sequence
        // ReactiveX에서는 Stream이라 표현하고, RxSwift에서는 Seqence라고 많이 표현
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text.orEmpty.share()
        // 내부에 share가 들어가있는 Subject, Relay
        
        validation
            .map { $0.count >= 8 } // Bool
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
//            .subscribe(onNext: { value in
//                self.stepButton.isEnabled = value
//                self.validationLabel.isEnabled = value
//            })
        
//            .bind(onNext: { value in
//                self.stepButton.isEnabled = value
//                self.validationLabel.isEnabled = value
//            })
        
        validation
            .map { $0.count >= 8 ? UIColor.systemPink : UIColor.lightGray }
            .bind(to: stepButton.rx.backgroundColor)
            .disposed(by: disposeBag)
//            .bind { value in
//                let color: UIColor = value ? .systemPink : .lightGray
//                self.stepButton.backgroundColor = color
//            }

        
        stepButton.rx.tap
            .bind { _ in
                print("SHOW ALERT42")
            }
            .disposed(by: disposeBag) // dispose는 리소스 정리, deinit시 정리됨.
            //.dipose() // .disposed(by: DisposeBag()) => 수동으로 리소스를 정리할 때 사용
    }
    
//    func observableVSSubject() {
///*
//    let testA = stepButton.rx.tap
//        .map { "안녕하세요" }
//        .asDriver(onErrorJustReturn: "")
//            .share()
//
//    testA
//        .drive(validationLabel.rx.text)
//        .disposed(by: disposeBag)
//
//    testA
//        .drive(nameTextField.rx.text)
//        .disposed(by: disposeBag)
//
//    testA
//        .drive(stepButton.rx.title())
//        .disposed(by: disposeBag)
//*/
//
//
//
//            let testA = stepButton.rx.tap
//                .map { "안녕하세요"}
//                .share()
//
//            testA
//                .bind(to: validationLabel.rx.text)
//                .disposed(by: disposeBag)
//
//            testA
//                .bind(to: nameTextField.rx.text)
//                .disposed(by: disposeBag)
//
//            testA
//                .bind(to: stepButton.rx.title())
//                .disposed(by: disposeBag)
//
//
//
//        let sampleInt = Observable<Int>.create { observer in
//            observer.onNext(Int.random(in: 1...100))
//            return Disposables.create()
//        }
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        sampleInt.subscribe { value in
//            print("sampleInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        let subjectInt = BehaviorSubject(value: 0)
//        subjectInt.onNext(Int.random(in: 1...100))
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//
//        subjectInt.subscribe { value in
//            print("subjectInt: \(value)")
//        }
//        .disposed(by: disposeBag)
//    }
}
