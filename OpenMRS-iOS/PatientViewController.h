//
//  PatientViewController.h
//  
//
//  Created by Parker Erway on 12/1/14.
//
//

#import <UIKit/UIKit.h>
#import "MRSPatient.h"
@interface PatientViewController : UITableViewController
@property (nonatomic, strong) MRSPatient *patient;
@property (nonatomic, strong) NSArray *information;
@property (nonatomic, strong) NSArray *visits;
@property (nonatomic, strong) NSArray *encounters;

@property (nonatomic, strong) NSArray* vitalSigns;
@property (nonatomic) BOOL vitalSignsExpanded;
@property (nonatomic) BOOL vitalSignsError;
@end
