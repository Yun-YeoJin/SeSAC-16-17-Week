//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let viewModel = SubjectViewModel()
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    //Array<String>() : 요런식으로 표현한 것
    
    let behavior = BehaviorSubject(value: 100) // 초기값이 필수로 들어있다.
    
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //bufferSize에 작성된 이벤트만큼 메모리에서 이벤트를 가지고 있다가, Subscribe 직후 한 번에 이벤트를 전달
    
    let async = AsyncSubject<Int>()
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newButton.rx.tap, searchText: searchBar.rx.text)
        
        let output = viewModel.transform(input: input)
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.text = "\(element.name): \(element.age)세 , 전화번호 : \(element.number)"
            }
            .disposed(by: disposebag)
        
        input.addTap // VC -> VM (Input)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposebag)
        
        input.resetTap // VC -> VM (Input)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.resetData()
            }
            .disposed(by: disposebag)
        
        input.newTap // VC -> VM (Input)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.newData()
            }
            .disposed(by: disposebag)
        
        output.searchText
            .withUnretained(self)
            .subscribe { vc, value in
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposebag)
    }
    
}

extension SubjectViewController {
    
    func asyncSubject() {
        
        `async`.onNext(100)
        `async`.onNext(200)
        `async`.onNext(300)
        `async`.onNext(400)
        `async`.onNext(500)
        
        `async`
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposebag)
        
        `async`.onNext(3) // 값 방출해주기
        `async`.on(.next(5))
        
        `async`.onCompleted()
        
        `async`.onNext(6)
        
    }
    
    func replaySubject() {
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposebag)
        
        replay.onNext(3) // 값 방출해주기
        replay.on(.next(5))
        
        replay.onCompleted()
        
        replay.onNext(6)
    }
    
    func behaviorSubject() {
        
        //구독 전에 가장 최근 값을 같이 emit
        
        //behavior.onNext(1)
        //behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposebag)
        
        behavior.onNext(3) // 값 방출해주기
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
    }
    
    func publishSubject() {
        
        // 초기값이 없는 빈 상태, Subscribe 전 error/ completed notification 이후 이벤트는 무시
        // Subscribe 후에 대한 이벤트는 다 처리
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposebag)
        
        publish.onNext(3) // 값 방출해주기
        publish.on(.next(5))
        
        publish.onCompleted()
        
        publish.onNext(6)
        
    }
    
}
