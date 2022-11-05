//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/27.
//

import Foundation

import RxSwift
import RxCocoa

class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8자 이상 필요해요. 첫 글자는 대문자가 필요해요.")
    
    
    struct Input {
        let text: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
        let text: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let valid = input.text
            .orEmpty
            .map { $0.count >= 8 }
            .share() //Subject, Relay
        
        let text = validText.asDriver()
        
        return Output(validation: valid, tap: input.tap, text: text)
    }
    
}
