//
//  EditDeleteViewController.h
//  SQLiteWithiOS
//
//  Created by Anuja Piyadigama on 12/7/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UndergraduateObj.h"

@interface EditDeleteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *uniIdLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *gpaTextField;

- (void)selectedUndergrad:(UndergraduateObj *)underGrad;

- (IBAction)editAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;
- (IBAction)textFieldReturn:(UITextField *)sender;

@end
