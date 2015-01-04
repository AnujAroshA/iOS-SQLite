//
//  EditDeleteViewController.m
//  SQLiteWithiOS
//
//  Created by Anuja Piyadigama on 12/7/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import "EditDeleteViewController.h"
#import "AppConstants.h"
#import "SQLiteDBManager.h"

@interface EditDeleteViewController () {
    
    NSString *selectedUngradName;
    NSString *selectedUngradGpa;
    NSString *selectedUngradUniId;
}

@end

@implementation EditDeleteViewController

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    _uniIdLabel.text = selectedUngradUniId;
    _nameTextField.text = selectedUngradName;
    _gpaTextField.text = selectedUngradGpa;
}

#pragma mark - Action methods

- (void)selectedUndergrad:(UndergraduateObj *)underGrad {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    if (debugEnable) NSLog(@"%s - %d # Name = %@", __PRETTY_FUNCTION__, __LINE__, underGrad.undergradName);
    if (debugEnable) NSLog(@"%s - %d # GPA = %@", __PRETTY_FUNCTION__, __LINE__, underGrad.undergradGpa);
    if (debugEnable) NSLog(@"%s - %d # Uni ID = %@", __PRETTY_FUNCTION__, __LINE__, underGrad.undergradUniId);
    
    selectedUngradName = underGrad.undergradName;
    selectedUngradGpa = underGrad.undergradGpa;
    selectedUngradUniId = underGrad.undergradUniId;
    
}

- (IBAction)editAction:(UIButton *)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    BOOL editStatus = [[SQLiteDBManager sharedInstance] updateName:_nameTextField.text uniId:selectedUngradUniId gpa:_gpaTextField.text];
    
    if (editStatus) {
        [self performSegueWithIdentifier:@"toHomeSegue" sender:self];
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    BOOL deleteStatus = [[SQLiteDBManager sharedInstance] deleteUnderGrad:selectedUngradUniId];
    
    if (deleteStatus) {
        [self performSegueWithIdentifier:@"toHomeSegue" sender:self];
    }
}

- (IBAction)textFieldReturn:(UITextField *)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
}

#pragma mark - supportive methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
