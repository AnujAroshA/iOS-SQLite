//
//  FunctioningViewController.m
//  SQLiteWithiOS
//
//  Created by Anuja on 10/8/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import "FunctioningViewController.h"
#import "AppConstants.h"
#import "SQLiteDBManager.h"

static NSString const *TAG = @"FunctioningViewController";

@interface FunctioningViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *uniIdTxtField;
@property (weak, nonatomic) IBOutlet UITextField *gpaTxtField;

@end

@implementation FunctioningViewController

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    [_nameTxtField becomeFirstResponder];
}

#pragma mark - Action methods

- (IBAction)saveAction:(UIButton *)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSString *undGradName = _nameTxtField.text;
    NSString *undGradUniId = _uniIdTxtField.text;
    NSString *undGradGpa = _gpaTxtField.text;
    
    BOOL isSuccess = [[SQLiteDBManager sharedInstance] insertName:undGradName uniId:undGradUniId gpa:undGradGpa];
    
    if (isSuccess) {
        if (debugEnable) NSLog(@"%s - %d # success", __PRETTY_FUNCTION__, __LINE__);
        
        _nameTxtField.text = @"";
        _uniIdTxtField.text = @"";
        _gpaTxtField.text = @"";
        
        [_nameTxtField becomeFirstResponder];
        
    } else {
        if (debugEnable) NSLog(@"%s - %d # fail", __PRETTY_FUNCTION__, __LINE__);
    }
}

- (IBAction)textFieldReturn:(UITextField *)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    [sender resignFirstResponder];
}
@end
