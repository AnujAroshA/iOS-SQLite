//
//  ViewController.m
//  SQLiteWithiOS
//
//  Created by Anuja on 10/8/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import "ViewController.h"
#import "AppConstants.h"
#import "SQLiteDBManager.h"
#import "UndergraduateObj.h"
#import "EditDeleteViewController.h"

static NSString const *TAG = @"ViewController";

@interface ViewController () {
    
    NSArray *undergraduatesArr;
}

@end

@implementation ViewController

#pragma mark - ViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    undergraduatesArr = [[NSArray alloc] init];
    undergraduatesArr = [[SQLiteDBManager sharedInstance] retrieveAllUndergrads];
    
}

#pragma mark - UITableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return undergraduatesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *tableCellIdentifier = @"UndergradTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    cell.textLabel.text = [[undergraduatesArr objectAtIndex:indexPath.row] undergradName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    [self performSegueWithIdentifier:@"editDeleteSegue" sender:[undergraduatesArr objectAtIndex:indexPath.row]];
}

#pragma mark - Navigation method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    if ([[segue identifier] isEqualToString:@"editDeleteSegue"]) {
        EditDeleteViewController *editDeleteViewCont = [segue destinationViewController];
        [editDeleteViewCont selectedUndergrad:sender];
    }  
}

@end
