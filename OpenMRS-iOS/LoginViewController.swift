//
//  LoginViewController.swift
//  OpenMRS-iOS
//
//  Created by Parker on 4/20/16.
//  Copyright © 2016 Erway Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var hostField: UITextField! {
        didSet {
            hostField.addTarget(self, action: #selector(LoginViewController.updateHost(sender:)), for: .editingChanged)
        }
    }
    var usernameField: UITextField! {
        didSet {
            usernameField.addTarget(self, action: #selector(LoginViewController.updateUsername(sender:)), for: .editingChanged)
        }
    }
    var passwordField: UITextField! {
        didSet {
            passwordField.addTarget(self, action: #selector(LoginViewController.updatePassword(sender:)), for: .editingChanged)
        }
    }

    var host: String!
    var username: String!
    var password: String!

    @IBAction func useDemoServerTapped(_ sender: Any) {
        self.hostField.text = "https://demo.openmrs.org/openmrs"
        self.updateHost(sender: self.hostField)

        self.usernameField.text = "admin"
        self.updateUsername(sender: self.usernameField)

        self.passwordField.text = "Admin123"
        self.updatePassword(sender: self.passwordField)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default

        tableView.reloadData()
        tableView.layoutIfNeeded()
        self.hostField.becomeFirstResponder()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 3
        }
        else
        {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell")! as! LoginFieldCell

            cell.legendLabel.text = ["Host", "Username", "Password"][indexPath.row]
            cell.textField.placeholder = ["Host", "Username", "Password"][indexPath.row]
            cell.textField.text = [host, username, password][indexPath.row]
            cell.textField.delegate = self
            cell.textField.returnKeyType = .next

            switch indexPath.row {
                case 0:
                    hostField = cell.textField
                case 1:
                    usernameField = cell.textField
                case 2:
                    passwordField = cell.textField
                    cell.textField.isSecureTextEntry = true
                    cell.textField.returnKeyType = .go
                default: break
            }

            cell.selectionStyle = .none

            return cell
        }
        else
        {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Login"
            cell.textLabel?.textColor = UIColor(red: 39/255, green: 139/255, blue: 146/255, alpha: 1)

            return cell
        }
    }

    func login()
    {
        if host == nil || host == "" || username == nil || username == "" || password == nil || password == ""
        {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Warning label error"), message: "One or more fields are empty. All are required.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

            self.show(alert, sender: nil)

            return
        }

        host = addProtocolToHost(hostString: host)
        self.hostField.text = host

        MBProgressExtension.showBlock(withTitle: NSLocalizedString("Loading", comment: "Label loading"), in: self.view)
        OpenMRSAPIManager.verifyCredentials(withUsername: username, password: password, host: host) { (error: Error!) in
            if error == nil
            {
                MBProgressExtension.showSucess(withTitle: NSLocalizedString("Logged in", comment: "Message -logged- -in-"), in: self.presentingViewController!.view)
                self.updateKeychainItemWithHost(host: self.host, username: self.username, password: self.password)

                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                }
            }
            else
            {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Warning label error"), message: NSLocalizedString("Invalid credentials", comment: "warning label invalid credentials"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

                self.show(alert, sender: nil)
            }
            
        }
    }

//    - (void)updateKeychainWithHost:(NSString *)host username:(NSString *)username password:(NSString *)password
//    {
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"OpenMRS-iOS" accessGroup:nil];
//    [wrapper setObject:password forKey:(__bridge id)(kSecValueData)];
//    [wrapper setObject:username forKey:(__bridge id)(kSecAttrAccount)];
//    [wrapper setObject:host forKey:(__bridge id)(kSecAttrService)];
//    }

    func updateKeychainItemWithHost(host: String, username: String, password: String)
    {
        let wrapper = KeychainItemWrapper.init(identifier: "OpenMRS-iOS", accessGroup: nil)
        wrapper?.setObject(host, forKey: kSecAttrService)
        wrapper?.setObject(username, forKey: kSecAttrAccount)
        wrapper?.setObject(password, forKey: kSecValueData)
    }


    func addProtocolToHost(hostString: String) -> String {
        if !hostString.hasPrefix("htt") // Account for both http and https. Not perfect, but it works
        {
            return "https://".appendingFormat(hostString)
        }

        return hostString
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 38
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1
        {
            login()
        }

        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    @objc
    func updateUsername(sender: UITextField!)
    {
        username = sender.text
    }

    @objc
    func updatePassword(sender: UITextField!)
    {
        password = sender.text
    }

    @objc
    func updateHost(sender: UITextField!)
    {
        host = sender.text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hostField
        {
            usernameField.becomeFirstResponder()
        }
        else if textField == usernameField
        {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField
        {
            login()
        }
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return .all
        }
        else
        {
            return .portrait
        }
    }
}
