//
//  LandingPageViewController.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import "LandingPageViewController.h"
#import "PatientSearchViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) showPatientSearch {
    PatientSearchViewController* search = [[PatientSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:search animated:YES];
}
@end
