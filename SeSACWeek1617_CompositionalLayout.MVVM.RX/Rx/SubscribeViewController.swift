//
//  SubscribeViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> { dataSource, tableView, IndexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    }
    
    func textRxDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([SectionModel(model: "title", items: [1, 2, 3]),
                         SectionModel(model: "title", items: [1, 2, 3]),
                         SectionModel(model: "title", items: [1, 2, 3]) ])
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
    }
    
    func testRxAlamofire() {
        // Success Error => <Single> : 보다 편의를 위해 만들어진 객체
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization" : APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe { value in
                print(value.results[0].likes)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRxAlamofire()
        textRxDataSource()
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)
            .filter { $0 % 2 == 0 }
//            .debug()
            .map { $0 * 2 }
            .subscribe { value in
            }
            .disposed(by: disposeBag)
        // 1.
        let sample = button.rx.tap
        
        sample
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 2. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업이 이워진다면? -> UI 변경 작업은 Main 쓰레드에서 작업을 해줘야 함.
        button.rx.tap
            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 3. bind - bind는 무조건 Main 쓰레드에서 동작.
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        // 4. operator로 데이터의 stream 조작
        button
            .rx
            .tap
            .map { "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        // 5. driver traits - bind와 동일한 역할, + stream 공유(리소스 낭비를 방지해 준다, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "ERROR")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }
    
}
