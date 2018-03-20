//
//  ViewController.swift
//  MultiPeer_Sample
//
//  Created by Wilson Ding on 3/20/18.
//  Copyright © 2018 Wilson Ding. All rights reserved.
//

import UIKit
import MultiPeer

enum DataType: UInt32 {
    case message = 1
}

class ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!

    @IBOutlet weak var outputMessageTextField: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        MultiPeer.instance.delegate = self

        MultiPeer.instance.initialize(serviceType: "sample-app")
        MultiPeer.instance.autoConnect()
    }

    override func viewWillDisappear(_ animated: Bool) {
        MultiPeer.instance.disconnect()

        super.viewWillDisappear(animated)
    }

    @IBAction func didPressSendButton(_ sender: Any) {
        guard let message = inputTextField.text else { return }

        MultiPeer.instance.send(object: message, type: DataType.message.rawValue)
    }

}

extension ViewController: MultiPeerDelegate {

    func multiPeer(didReceiveData data: Data, ofType type: UInt32) {
        switch type {
        case DataType.message.rawValue:
            guard let message = data.convert() as? String else { return }
            outputMessageTextField.text = message
            break;

        default:
            break;
        }
    }

    func multiPeer(connectedDevicesChanged devices: [String]) {
        print("Connected devices changed: \(devices)")
    }
}
