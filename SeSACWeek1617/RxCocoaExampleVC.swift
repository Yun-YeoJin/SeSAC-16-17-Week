//
//  RxCocoaExampleVC.swift
//  SeSACWeek1617
//
//  Created by 윤여진 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleVC: UIViewController {
    
    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setPickerView()
        setSwtich()
        setSign()
        setOperator()
        
    }
    
    func setOperator() {
        
        Observable.repeatElement("YUN")
            .take(5)
            .subscribe { value in
                print("repeatElement - \(value)")
            } onError: { error in
                print("repeatElement - \(error)")
            } onCompleted: {
                print("repeatElement completed")
            } onDisposed: {
                print("repeatElement disposed")
            }
            .disposed(by: disposeBag)
        
        let intervalObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            //.disposed(by: disposeBag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            intervalObservable.dispose()
        }
        
        
        let itemA = [3.3, 4.0, 5.1, 2.1, 3.6, 4.8]
        let itemB = [2.3, 2.0, 1.3]
        
        Observable.just(itemA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemA, itemB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)

        Observable.from(itemA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)

        
    }
    
    func setSign() {
        //TextField 1번 (Observable) + TextField 2번 (Observable) >> 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, Email은 \(value2)입니다."
        }
        .bind(to: simpleLabel.rx.text) //simpleLabel에 보내준다.
        .disposed(by: disposeBag)
        
        signName.rx.text.orEmpty
            .map { $0.count } //map을 이용해서 글자를 가져온다. -> Int로 변환
            .map { $0 < 4 } //Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden) //하나의 바인드에 여러개 옵저버를 둘 수 있다.
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showSesacAlert(title: "RxSwift", message: "너무 신기해용!!")
            }
            .disposed(by: disposeBag)
        
    }
    
    func showSesacAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }
    
    func setSwtich() {
        
        Observable.of(false) //just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self) //items가 String이라서
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
                return element //String이니까 .title은 필요없음
            }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
        
//            .subscribe(onNext: { value in
//                print(value)
//            }, onError: { error in
//                print("Error")
//            }, onCompleted: {
//                print("Complete")
//            }, onDisposed: {
//                print("Dispose")
//            })
        
            .disposed(by: disposeBag)
    }
    
}
