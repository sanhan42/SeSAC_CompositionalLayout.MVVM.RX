//
//  ViewController.swift
//  SeSACWeek1617_CompositionalLayout.MVVM.RX
//
//  Created by 한상민 on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {
    
    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration() // 구조체 이기에, 프로퍼티 수정을 위해서는 var로 선언해야한다.
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "안녕하세요. \(indexPath.row)" // detailTextLabel
        cell.contentConfiguration = content
        
        return cell
    }
}

