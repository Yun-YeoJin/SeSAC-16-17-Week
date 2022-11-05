//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/25.
//

import Foundation

import RxSwift
import RxCocoa

//associated type == Generic
//왜 제네릭처럼 써야할까? -> 내부에 구성되어 있는 프로퍼티는 매우 다양하기 때문이다.
//Input: Codable 처럼 제약을 걸 수도 있다.
protocol CommonViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

struct Contact {
    var name: String
    var age: Int
    var number: String
    
}

class SubjectViewModel: CommonViewModel {
    
    var contactData = [
    Contact(name: "YUN", age: 27, number: "01012345867"),
    Contact(name: "DEE", age: 34, number: "01098233467"),
    Contact(name: "YONG", age: 26, number: "01047374930"),
    ]
    
    var list = PublishRelay<[Contact]>()
    
    func fetchData() {
        list.accept(contactData) // list에 contact 데이터를 추가하겠다.
    }
    
    func resetData() {
        list.accept([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "")
        
        contactData.append(new)
        list.accept(contactData)
        
        //list.onNext([new]) : 이건 덮어쓰기가 된다.
        
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.accept(result)
        
    }
    
    struct Input {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct Output {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]> //Input 값이 없어서
        let searchText: Observable<String>

    }
    
    func transform(input: Input) -> Output {
        
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText
            .orEmpty // VC -> VM (Input)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //wait
            .distinctUntilChanged() //같은 값을 받지 않음
        
        return Output(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
        
    }
}
