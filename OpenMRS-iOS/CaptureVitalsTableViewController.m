//
//  CaptureVitalsTableViewController.m
//  OpenMRS-iOS
//
//  Created by Parker Erway on 12/12/14.
//  Copyright (c) 2014 Erway Software. All rights reserved.
//

#import "CaptureVitalsTableViewController.h"
#import "OpenMRSAPIManager.h"
#import "LocationListTableViewController.h"
#import "MRSVital.h"

@interface CaptureVitalsTableViewController ()

@end

@implementation CaptureVitalsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Capture Vitals";
    
    self.fields = @[@{ @"label" : @"Height", @"units" : @"cm", @"uuid" : @"5090AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
                    @{ @"label" : @"Weight", @"units" : @"kg", @"uuid" : @"5089AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
//                    @{ @"label" : @"Calculated BMI", @"units" : @""},
                    @{ @"label" : @"Temperature", @"units" : @"C", @"uuid" : @"5088AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
                    @{ @"label" : @"Pulse", @"units" : @"", @"uuid" : @"5087AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
                    @{ @"label" : @"Respiratory rate", @"units" : @"/min", @"uuid" : @"5242AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},
//                    @{ @"label" : @"Blood Pressure", @"units" : @""},
                    @{ @"label" : @"Blood Oxygen Sat.", @"units" : @"%", @"uuid" : @"5092AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}];
    
    self.textFieldValues = [[NSMutableDictionary alloc] init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)done
{
    NSMutableArray *vitals = [[NSMutableArray alloc] init];
    for (NSString *key in self.textFieldValues.allKeys) {
        MRSVital *vital = [[MRSVital alloc] init];
        vital.conceptUUID = key;
        vital.value = self.textFieldValues[key];
        [vitals addObject:vital];
    }
    
    [OpenMRSAPIManager captureVitals:vitals toPatient:self.patient atLocation:self.currentLocation completion:^(NSError *error) {
        if (!error)
        {
            [self.delegate didCaptureVitalsForPatient:self.patient];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 1;
    }
    return self.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"locCell"];
        
        cell.textLabel.text = @"Location";
        
        if (self.currentLocation)
        {
            cell.detailTextLabel.text = self.currentLocation.display;
        }
        else
        {
            cell.detailTextLabel.text = @"Select...";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSDictionary *field = self.fields[indexPath.row];
    
    if ([field[@"units"] length] > 0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", field[@"label"], field[@"units"]];
    }
    else
    {
        cell.textLabel.text = field[@"label"];
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(cell.bounds.size.width-150, 0, 130, cell.bounds.size.height)];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = self.view.tintColor;
    textField.textAlignment = NSTextAlignmentRight;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textField.returnKeyType = UIReturnKeyDone;
    [textField addTarget:self action:@selector(textFieldDidUpdate:) forControlEvents:UIControlEventEditingChanged];
    
    textField.placeholder = @"Value";
    textField.text = self.textFieldValues[field[@"uuid"]];
    textField.tag = indexPath.row;
    
    [cell addSubview:textField];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        LocationListTableViewController *locList = [[LocationListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        locList.delegate = self;
        [self.navigationController pushViewController:locList animated:YES];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Location";
            break;
        case 1:
            return @"Vitals";
            break;
        default:
            return nil;
            break;
    }
}
- (void)textFieldDidUpdate:(UITextField *)sender
{
    NSDictionary *field = self.fields[sender.tag];
    
    [self.textFieldValues setObject:sender.text forKey:field[@"uuid"]];
}
-(void)didChooseLocation:(MRSLocation *)location
{
    self.currentLocation = location;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView reloadData];
}
@end
