//
//  ViewController.swift
//  AeroGearSdkExample
//

import AGSCore
import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var pickerView: UIPickerView!

    @IBOutlet var config: UILabel!

    var pickerDataSource = ["sync-server", "prometheus"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        config.text = "Empty"
    }

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return pickerDataSource.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return pickerDataSource[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        AgsCoreLogger.logger().info("Loading configuration")
        let configuration = AgsCore.instance.getConfiguration(pickerDataSource[row])
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(configuration)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("JSON String : " + jsonString!)
            config.text = jsonString
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
