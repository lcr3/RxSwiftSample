//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by ryookano on 2019/10/23.
//  Copyright © 2019 ryookano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ViewModel {
    let username = BehaviorRelay<String>(value: "")
}

class ViewController: UIViewController {
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!

    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    private let maxLength = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel の値が変化したとき、UILabel に表示する処理
        viewModel.username
            .bind(to: label.rx.text) // label.textに反映する
            .disposed(by: disposeBag)
        
        // UITextField に入力されたとき、ViewModel の値に反映させる処理
        textField.rx.text.orEmpty
            .bind(to: viewModel.username) // viewModel.usernameに反映する
            .disposed(by: disposeBag)
        
        
        textField.rx.text.subscribe(onNext: { text in
            if let text = text, text.count >= self.maxLength {
                self.textField.text = text.prefix(self.maxLength).description
            }
            
            self.label.text = self.textField.text
        }).disposed(by: disposeBag)
        
        // ボタンがタップされたとき
        button.rx.tap.bind {
            print(self.viewModel.username.value)
        }.disposed(by: disposeBag)
    }
}

