//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/18.
//

import UIKit

private let reuseIdentifier = "Cell"

struct User: Equatable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID().uuidString
    let name: String
    let age: Int
    
//    init(name: String, age: Int) {
//        self.name = name
//        self.age = age
//    }
}

class SimpleCollectionViewController: UICollectionViewController {

//    var list = ["삼계탕", "닭곰탕", "들기름김", "삼분카레", "콘소메 치킨"]
    
    var list = [User(name: "뽀로로", age: 3), User(name: "에디", age: 13), User(name: "해리포터", age: 33), User(name: "도라에몽", age: 5)]
    
    // https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성 되어야 한다.
    // cf. collectionView.register(UIcollectionView.self, forCellWithReuseIdentifier: "")와 같은 작업 (유사한 역할)
    // <#T##UICollectionView.CellRegistration<Cell, Item>#> - Cell : 사용할 Cell 타입, Item : 셀에 들어갈 데이터 타입
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        // 1. Identifier 등록이 없어짐. 2. struct 방식으로 변경됨. (참조가 아닌 복사)
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            // cell : display 될 collectionViewCell
            // itemIdentifier : 보여질 data type
            var content = UIListContentConfiguration.valueCell() // cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .red
            content.secondaryText = "\(itemIdentifier.age)"
            content.secondaryTextProperties.color = .white
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 10
            content.image = indexPath.item < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .yellow
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeColor = .systemRed
            backgroundConfig.strokeWidth = 2
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let item = list[indexPath.item]
//
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//
//
//
//        return cell
//    }
}

extension SimpleCollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        /* 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration) */
        // 컬렉션뷰 스타일 (컬렉션뷰 셀과는 관계 없다.)
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain) // CollectionView에 대한 설정
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
