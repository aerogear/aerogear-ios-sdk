//
//  ViewController.swift
//  AeroGearSdkExample
//

import AGSCore
import UIKit

class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    static let homeStoryBoard = UIStoryboard(name: "home", bundle: nil)

    @IBOutlet var pickerView: UIPickerView!

    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var config: UILabel!

    var currentConfig: MobileService?

    var pickerDataSource = ["keycloak", "metrics"]

    @IBAction func buttonClick(sender _: UIButton) {
        if let uri = currentConfig?.url {
            AgsCore.instance.getHttp().get(uri, { (response, error) -> Void in
                if let error = error {
                    AgsCore.logger.error("An error has occurred during read \(error)")
                    return
                }
                if let response = response as? [String: Any] {
                    self.responseLabel.textColor = UIColor.blue
                    self.responseLabel.text = response.description
                }
            })
        } else {
            responseLabel.textColor = UIColor.red
            responseLabel.text = "Select config first"
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

        AgsCore.logger.info("Loading configuration")
        currentConfig = AgsCore.instance.getConfiguration(pickerDataSource[row])
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(currentConfig)
            let jsonString = String(data: jsonData, encoding: .utf8)
            AgsCore.logger.debug("JSON String \(jsonString ?? "")")
            config.text = jsonString
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    static func loadViewController() -> UIViewController {
        return homeStoryBoard.instantiateViewController(withIdentifier: "HomeViewController")
    }
}
