//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/18.
//

import UIKit

struct User: Hashable {
    let name: String //Hashable
    let age: Int //Hashable
    //만약 Struct에서 열거형을 다루거나, 직접만든 Class를 다루거나 할 때 같은 데이터를 다루고 싶다면?
    let id = UUID().uuidString
}

class SimpleCollectionViewController: UICollectionViewController {
    
    var list = [
    User(name: "뽀로로", age: 3),
    User(name: "에디", age: 13),
    User(name: "해리포터", age: 33),
    User(name: "도라에몽", age: 200)
    ]
    
    //함수 밖에다가 만들어줘야 한다. (cellForItemAt 전에 생성되어야함!) -> register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createLayout()
        
        //cell: 디스플레이가 될 셀 정보
        //indexPath: (0, 3) 처럼 IndexPath 정보
        //itemIdentifier: 들어올 데이터 정보
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in

            var content = UIListContentConfiguration.valueCell() //셀 사이즈를 자동으로 조절해준다!
            //cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .systemRed
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false //애초에 내리고 싶으면 false
            content.textToSecondaryTextVerticalPadding = 20 //간격 설정
            
            content.image = itemIdentifier.age < 10 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .systemYellow
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .lightGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .magenta
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
//
//        let item = list[indexPath.item]
//        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//
//        return cell
//    }
}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        //iOS 14.0 + 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        //컬렉션뷰 스타일 (컬렉션 셀 X)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false // 구분선 표시
        configuration.backgroundColor = .brown
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
        
    }
}
