//
//  SimpleTableViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/18.
//

import UIKit

class SimpleTableViewController: UITableViewController {

    let list = ["슈비버거", "프랭크", "자갈치", "고래밥"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "안녕하세용" //detailTextLabel
        
        cell.contentConfiguration = content //등록!

        return cell
    }
}
