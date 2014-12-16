//
//  PatientSearchViewController.m
//  OpenMRS-iOS
//
//  Created by Parker Erway on 12/1/14.
//  
//

#import "PatientSearchViewController.h"
#import "OpenMRSAPIManager.h"
#import "MRSPatient.h"
#import "PatientViewController.h"

@implementation PatientSearchViewController
-(void)viewDidLoad
{
    self.title = @"Patients";
    [super viewDidLoad];
    [self reloadDataForSearch:@""];
    
    UISearchBar *bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bar.delegate = self;
    [bar sizeToFit];
    self.tableView.tableHeaderView = bar;
    [bar becomeFirstResponder];
    
}
-(void)reloadDataForSearch:(NSString *)search
{
    [OpenMRSAPIManager getPatientListWithSearch:search completion:^(NSError *error, NSArray *patients) {
        self.currentSearchResults = patients;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%lu", (unsigned long)self.currentSearchResults.count);
            [self.tableView reloadData];
        });
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentSearchResults.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    MRSPatient *patient = self.currentSearchResults[indexPath.row];
    
    cell.textLabel.text = patient.name;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRSPatient *patient = self.currentSearchResults[indexPath.row];
    
    PatientViewController *vc = [[PatientViewController alloc] initWithStyle:UITableViewStyleGrouped];
    vc.patient = patient;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self reloadDataForSearch:searchText];
}
@end
