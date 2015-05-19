//
//  StartVisitViewController.swift
//  OpenMRS-iOS
//
//  Created by Parker Erway on 1/22/15.
//  Copyright (c) 2015 Erway Software. All rights reserved.
//

import UIKit

@objc protocol StartVisitViewControllerDelegate
{
    func didCreateVisitForPatient(patient: MRSPatient)
}

class StartVisitViewController : UITableViewController, SelectVisitTypeViewDelegate, LocationListTableViewControllerDelegate
{
    var visitType: MRSVisitType!
    var cachedVisitTypes: [MRSVisitType]!
    var location: MRSLocation!
    var patient: MRSPatient!
    var delegate: StartVisitViewControllerDelegate!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Start Visit"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        
        self.reloadData()
        
        self.updateDoneButtonState()
    }
    
    func done()
    {
        OpenMRSAPIManager.startVisitWithLocation(location, visitType: visitType, forPatient: patient) { (error:NSError!) -> Void in
            if error == nil
            {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate?.didCreateVisitForPatient(self.patient)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    func reloadData()
    {
        OpenMRSAPIManager.getVisitTypesWithCompletion { (error:NSError!, types:[AnyObject]!) -> Void in
            if error == nil
            {
                self.cachedVisitTypes = types as [MRSVisitType]!
                if types.count == 1
                {
                    self.visitType = types[0] as MRSVisitType
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.updateDoneButtonState()
                    }
                }
            }
        }
    }
    
    func cancel()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "Visit Type"
        case 1:
            return "Location"
        default:
            return nil
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section
        {
        case 0:
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("visit_type") as UITableViewCell!
            
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "visit_type")
            }
            
            cell.textLabel?.text = "Visit Type"
            
            if visitType == nil
            {
                cell.detailTextLabel?.text = "Select Visit Type"
            }
            else
            {
                cell.detailTextLabel?.text = visitType.display
            }
            
            cell.accessoryType = .DisclosureIndicator
            
            return cell
        case 1:
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("location") as UITableViewCell!
            
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "location")
            }
            
            cell.textLabel?.text = "Location"
            
            if location == nil
            {
                cell.detailTextLabel?.text = "Select Location"
            }
            else
            {
                cell.detailTextLabel?.text = location.display
            }
            
            cell.accessoryType = .DisclosureIndicator
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section
        {
        case 0:
            let vc = SelectVisitTypeView(style: UITableViewStyle.Plain)
            vc.delegate = self
            vc.visitTypes = cachedVisitTypes
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = LocationListTableViewController(style: UITableViewStyle.Plain)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    func didChooseLocation(newLocation: MRSLocation) {
        location = newLocation
        self.navigationController?.popToRootViewControllerAnimated(true)
        tableView.reloadData()
        self.updateDoneButtonState()
    }
    
    func didSelectVisitType(type: MRSVisitType) {
        visitType = type
        tableView.reloadData()
        self.updateDoneButtonState()
    }
    
    func updateDoneButtonState() {
        self.navigationItem.rightBarButtonItem?.enabled = (location != nil && visitType != nil)
    }
}