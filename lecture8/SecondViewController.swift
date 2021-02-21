//
//  SecondViewController.swift
//  lecture8
//
//  Created by Магжан Бекетов on 21.02.2021.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func almatySend(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.arr = "Almaty"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func astanaSend(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.arr = "Astana"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func newYorkSend(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
        vc.arr = "NewYork"
        navigationController?.pushViewController(vc, animated: true)
    }
}
