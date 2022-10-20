//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/20.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    //1. ViewModel 가져오기
    var viewModel = NewsViewModel()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        
        bindData()
        
        configureViews()
        
    }
    
    @objc func resetButtonClicked() {
        viewModel.resetSample()
    }
    
    @objc func loadButtonClicked() {
        viewModel.loadSample()
    }
    
    @objc func numberTextFieldChanged() {
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text)
    }
    
    func configureViews() {
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadButtonClicked), for: .touchUpInside)

    }
    
    func bindData() {
        //2.bind 구문을 이용해 VC에 보여주기
        viewModel.pageNumber.bind { value in
            print("bind ====== \(value)")
            self.numberTextField.text = value
        }
        
        //추가 되더라도, 제거 되더라도 snapshot이 찍힌다.
        viewModel.sample.bind { item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
}

extension NewsViewController {

    func configureHierachy() { //addSubView, init, snapkit
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
        
    }
    
    func configureDataSource() { //셀 등록하기
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
       
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
