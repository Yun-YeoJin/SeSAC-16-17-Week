//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/27.
//

import UIKit

import RxCocoa
import RxSwift

class ValidationViewController: UIViewController {
    
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    let bag = DisposeBag()
    
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
            Observable.of(1, 2, 3)
                .map { $0 * $0 }
                .subscribe(onNext: { print($0) })
                .disposed(by: bag)
        
            //observableVSSubject()
        
    }
    
    func bindData() {
        
        //MARK: After
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: bag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: bag)
        
        output.validation
            .withUnretained(self)
            .bind { vc, value in
                let color: UIColor = value ? .systemMint : .systemGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: bag)
        
        output.tap
            .bind { _ in
                self.showSesacAlert(title: "RxSwift", message: "어려워요...")
            }
            .disposed(by: bag)
        
        
        
        //MARK: Before
        viewModel.validText // VM -> VC (Output)
            .asDriver() //BehaviorRelay여서
            .drive(validationLabel.rx.text) //drive
            .disposed(by: bag)
        
        
        let validation = nameTextField.rx.text //ViewModel의 Transform 함수에 들어있음
            .orEmpty
            .map { $0.count >= 8 }
            .share()

        validation // VC -> VM (Input)
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden) //bind 객체 사용
            .disposed(by: bag)
        

        validation // VC -> VM (Input)
            .withUnretained(self)
            .bind { vc, value in
                let color: UIColor = value ? .systemMint : .systemGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: bag)
        
        stepButton.rx.tap // VC -> VM (Input)
            .bind { _ in
                self.showSesacAlert(title: "RxSwift", message: "어려워요...")
            }
            .disposed(by: bag)
               
    }
    
    func showSesacAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    func observableVSSubject() {
        
        //MARK: Drive Test
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
            //.share()
        
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: bag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: bag)

        testA
            .drive(stepButton.rx.title())
            .disposed(by: bag)

        
        //MARK: Observable
        // just / of / from
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: bag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: bag)

        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: bag)
        
        //MARK: Subject
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: bag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: bag)

        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: bag)

    }
    
}
