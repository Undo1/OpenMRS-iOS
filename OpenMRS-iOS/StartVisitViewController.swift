//
//  StartVisitViewController.swift
//  OpenMRS-iOS
//
//  Created by Parker Erway on 1/22/15.
//

import UIKit

@objc protocol StartVisitViewControllerDelegate
{
    func didCreateVisitForPatient(patient: MRSPatient)
}

class StartVisitViewController : UITableViewController, SelectVisitTypeViewDelegate, LocationListTableViewControllerDelegate, UIViewControllerRestoration
{
    var visitType: MRSVisitType!
    var cachedVisitTypes: [MRSVisitType]!
    var location: MRSLocation!
    @objc var patient: MRSPatient!
    @objc var delegate: StartVisitViewControllerDelegate!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableView.Style) {
        super.init(style: UITableView.Style.grouped)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)
    }

    @objc
    func updateFontSize() {
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restorationIdentifier = String(describing: self)
        self.restorationClass = type(of: self)

        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector:#selector(StartVisitViewController.updateFontSize), name: UIContentSizeCategory.didChangeNotification, object: nil)
        MRSHelperFunctions.updateTableView(forDynamicTypeSize: self.tableView)

        self.title = NSLocalizedString("Start Visit", comment: "Label -start- -visit-")

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(StartVisitViewController.cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(StartVisitViewController.done))

        self.reloadData()

        self.updateDoneButtonState()
    }

    @objc
    func done()
    {
        MBProgressExtension.showSucess(withTitle: NSLocalizedString("Loading", comment: "Label loading"), in: self.view)
        OpenMRSAPIManager.startVisit(with: location, visitType: visitType, for: patient) { (error: Error!) -> Void in
            if error == nil
            {
                MBProgressExtension.hideActivityIndicator(in: self.view)
                DispatchQueue.main.async {
                    self.delegate?.didCreateVisitForPatient(patient: self.patient)
                    MBProgressExtension.showSucess(withTitle: NSLocalizedString("Completed", comment: "Label loading"), in: self.presentingViewController?.view)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                MRSAlertHandler.alertViewForError(self, error: error).show()
            }
        }
    }

    func reloadData()
    {
        MBProgressExtension.showSucess(withTitle: NSLocalizedString("Loading", comment: "Label loading"), in: self.view)
        OpenMRSAPIManager.getVisitTypes { (error: Error!, types: [Any]!) -> Void in
            MBProgressExtension.hideActivityIndicator(in: self.view)
            if error == nil
            {
                self.cachedVisitTypes = types as! [MRSVisitType]?
                if types.count == 1
                {
                    self.visitType = types[0] as! MRSVisitType

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.updateDoneButtonState()
                    }
                }
            } else {
                MRSAlertHandler.alertViewForError(self, error: error).show()
            }
        }
    }

    @objc
    func cancel()
    {
        self.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return NSLocalizedString("Visit Type", comment: "Label -visit- -type-")
        case 1:
            return NSLocalizedString("Location", comment:"Label location")
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "visit_type")

            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "visit_type")
            }

            cell.textLabel?.text = NSLocalizedString("Visit Type", comment: "Label -visit- -type-")

            if visitType == nil
            {
                cell.detailTextLabel?.text = NSLocalizedString("Select visit Type", comment: "Label -select- -visit- -type-")
            }
            else
            {
                cell.detailTextLabel?.text = visitType.display
            }

            cell.accessoryType = .disclosureIndicator

            return cell
        case 1:
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "location")

            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "location")
            }

            cell.textLabel?.text = NSLocalizedString("Location", comment:"Label location")

            if location == nil
            {
                cell.detailTextLabel?.text = NSLocalizedString("Select Location", comment: "Label -select- -location-")
            }
            else
            {
                cell.detailTextLabel?.text = location.display
            }

            cell.accessoryType = .disclosureIndicator

            return cell
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section
        {
        case 0:
            let vc = SelectVisitTypeView(style: UITableView.Style.plain)
            vc.delegate = self
            vc.visitTypes = cachedVisitTypes
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = LocationListTableViewController(style: UITableView.Style.plain)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }

    func didChoose(_ location: MRSLocation!) {
        self.location = location
        self.navigationController?.popToRootViewController(animated: true)
        tableView.reloadData()
        self.updateDoneButtonState()
    }

    func didSelectVisitType(type: MRSVisitType) {
        visitType = type
        tableView.reloadData()
        self.updateDoneButtonState()
    }

    func updateDoneButtonState() {
        self.navigationItem.rightBarButtonItem?.isEnabled = (location != nil && visitType != nil)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(self.patient, forKey: "patient")
        coder.encode(self.delegate, forKey: "delegate")
        let nils:[Bool] = [self.visitType == nil, self.location == nil]
        coder.encode(nils, forKey:"nils")
        coder.encode(self.visitType, forKey: "visitType")
        coder.encode(self.location, forKey: "location")
    }

    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        let startVisit: StartVisitViewController = StartVisitViewController(style: UITableView.Style.grouped)
        startVisit.patient = coder.decodeObject(forKey: "patient") as! MRSPatient
        startVisit.delegate = coder.decodeObject(forKey: "delegate") as! StartVisitViewControllerDelegate
        let nils:[Bool] = coder.decodeObject(forKey: "nils") as! Array
        if (nils[0]==false) {
            startVisit.visitType = coder.decodeObject(forKey: "visitType") as! MRSVisitType;
        }
        if (nils[1]==false) {
            startVisit.location = coder.decodeObject(forKey: "location") as! MRSLocation
        }
        return startVisit
    }
}
