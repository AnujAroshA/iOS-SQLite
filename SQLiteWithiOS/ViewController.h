//
//  ViewController.h
//  SQLiteWithiOS
//
//  Created by Anuja on 10/8/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *undergradTableView;

@end

