//
//  ViewController.swift
//  AeroGearSdkExample
//

import AGSCore
import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var pickerView: UIPickerView!

    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var config: UILabel!
    
    let coreInstance = AgsCore()
    var currentConfig: MobileService?
    
    var pickerDataSource = ["sync-server", "prometheus", "echo"]

    @IBAction func buttonClick(sender _: UIButton) {
        if let uri = currentConfig?.config?.uri {
            let http = coreInstance.getHttp()
            http.getHttp().request(method: .post, path: uri, completionHandler: { (response, error) -> Void in
                if error != nil {
                    print("An error has occured during read! \(error!)")
                    return
                }
                if let response = response as? [String: Any] {
                    self.responseLabel.textColor = UIColor.blue
                    self.responseLabel.text = response.description
                }
            })
        } else {
            self.responseLabel.textColor = UIColor.red
            self.responseLabel.text = "Select config first"
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        config.text = "Select config file"
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
        self.currentConfig = coreInstance.getConfiguration(pickerDataSource[row])
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(currentConfig)
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
