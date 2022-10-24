//
//  DiffableViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/19.
//

import UIKit
import Kingfisher

class DiffableViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel = DiffableViewModel()
    
    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>!
        
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.collectionViewLayout = createLayout()
        
        searchBar.delegate = self
        
        configureDataSource()

        viewModel.photoList.bind { photo in
            
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>() //인스턴스 처럼 생성
            snapshot.appendSections([0])//섹션 추가
            snapshot.appendItems(photo.results)//아이템 추가
            self.dataSource.apply(snapshot)
            
        }
   
    }
    
}

extension DiffableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        viewModel.requestSearchPhoto(query: searchBar.text!)
        
    }
    
}

extension DiffableViewController {

    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = "\(itemIdentifier.likes)"
            
            // String -> URL -> Data -> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)! //String -> URL
                let data = try? Data(contentsOf: url) //URL -> Data
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!) //Data를 기반으로 Image 표현
                    cell.contentConfiguration = content //main에서 담아줘야한다!
                }
            }
                        
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .brown
            cell.backgroundConfiguration = backgroundConfig
            
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
    
    }
}
