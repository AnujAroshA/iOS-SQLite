//
//  SQLiteDBManager.h
//  SQLiteWithiOS
//
//  Created by Anuja on 10/8/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteDBManager : NSObject

+ (SQLiteDBManager *)sharedInstance;
- (BOOL)createdDatabase;
- (BOOL)insertName:(NSString *)name uniId:(NSString *)uniId gpa:(NSString *)gpa;
- (NSArray *)retrieveAllUndergrads;
- (BOOL)updateName:(NSString *)name uniId:(NSString *)uniId gpa:(NSString *)gpa;
- (BOOL)deleteUnderGrad:(NSString *)uniId;

@end
