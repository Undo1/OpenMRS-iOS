//
//  LandingPageViewController.m
//  OpenMRS-iOS
//
//  Created by BC Holmes on 2014-12-08.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import "LandingPageViewController.h"
#import "PatientSearchViewController.h"
#import "UIButton+Extensions.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.patientSearchButton centerImageAndTitle];
    
    self.navigationController.navigationBar.barTintColor = [AppDelegate instance].theme.navigationBarColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary* navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = navbarTitleTextAttributes;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettings)];
    self.title = @"OpenMRS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) showPatientSearch {
    PatientSearchViewController* search = [[PatientSearchViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)showSettings
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navcon = [[UINavigationController alloc] initWithRootViewController:settings];
    
    [self presentViewController:navcon animated:YES completion:nil];
}
@end
