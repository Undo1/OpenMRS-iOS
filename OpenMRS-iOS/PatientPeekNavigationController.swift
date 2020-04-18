//
//  PatientPeekNavigationController.swift
//  OpenMRS-iOS
//
//  Created by Parker on 4/19/16.
//  Copyright © 2016 Erway Software. All rights reserved.
//

import UIKit

class PatientPeekNavigationController : UINavigationController {
    @objc var patient: MRSPatient!
    @objc var searchController: PatientSearchViewController!

    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
        let editAction = UIPreviewAction(title: NSLocalizedString("Edit patient", comment: "Title -Edit- -patient-"), style: .default) { (action: UIPreviewAction, viewController: UIViewController) in
            let navigationController = viewController as! UINavigationController
            let patientViewController = navigationController.viewControllers[0] as! PatientViewController

            patientViewController.presentEdit(patientViewController.patient, from: UIApplication.shared.keyWindow?.rootViewController)
        }

        let captureVitalsAction = UIPreviewAction(title: NSLocalizedString("Capture Vitals", comment: "Label -capture- -vitals-"), style: .default) { (action: UIPreviewAction, viewController: UIViewController) in
            let navigationController = viewController as! UINavigationController
            let patientViewController = navigationController.viewControllers[0] as! PatientViewController

            patientViewController.presentCaptureVitalsViewController(patientViewController.patient, from: UIApplication.shared.keyWindow?.rootViewController)
        }

        return [editAction, captureVitalsAction]
    }
}
