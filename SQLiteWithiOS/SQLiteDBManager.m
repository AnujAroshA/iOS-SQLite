//
//  SQLiteDBManager.m
//  SQLiteWithiOS
//
//  Created by AnujAroshA on 10/26/14.
//  Copyright (c) 2014 AnujAroshA. All rights reserved.
//

#import "SQLiteDBManager.h"
#import "AppConstants.h"
#import "UndergraduateObj.h"

static NSString const *TAG = @"SQLiteDBManager";
static SQLiteDBManager *singletonInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@interface SQLiteDBManager () {

    NSString *databasePath;
}
@end


@implementation SQLiteDBManager

+ (SQLiteDBManager *)sharedInstance {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    if (!singletonInstance) {
        singletonInstance = [[super alloc] init];
        
        [singletonInstance createdDatabase];
    }
    
    return singletonInstance;
}

- (BOOL)createdDatabase {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    NSArray *directoryPathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [directoryPathsArray objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:@"undergraduate_gpa_db"]];
    if (debugEnable) NSLog(@"%s - %d # databasePath = %@", __PRETTY_FUNCTION__, __LINE__, databasePath);
    
    BOOL fileExistency = [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
    
    BOOL isSuccess = YES;
    
    if (fileExistency == NO) {
        
        const char *utf8Dbpath = [databasePath UTF8String];
        
//        https://www.sqlite.org/c3ref/open.html
        if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
            
            char *errorMsg;
            
            const char *sqlQueryToCreateUndergraduateDetailsTable = "create table if not exists undergraduate_details_table (undergraduate_name_column text, undergraduate_uni_id_column text primary key, undergraduate_gpa_column real)";
            
//            https://www.sqlite.org/c3ref/exec.html
            if (sqlite3_exec(database, sqlQueryToCreateUndergraduateDetailsTable, NULL, NULL, &errorMsg) != SQLITE_OK) {
                
                isSuccess = NO;
                if (debugEnable) NSLog(@"%s - %d # errorMsg = %s", __PRETTY_FUNCTION__, __LINE__, errorMsg);
            }
            
//            https://www.sqlite.org/c3ref/close.html
            sqlite3_close(database);
            return isSuccess;
            
        } else {
            isSuccess = NO;
            if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        }
    }

    return isSuccess;
}

- (BOOL)insertName:(NSString *)name uniId:(NSString *)uniId gpa:(NSString *)gpa {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into undergraduate_details_table (undergraduate_name_column, undergraduate_uni_id_column, undergraduate_gpa_column) values (\"%@\", \"%@\", \"%f\")", name, uniId, [gpa doubleValue]];
        
        const char *utf8InsertQuery = [insertQuery UTF8String];
        
//        https://www.sqlite.org/c3ref/prepare.html
        sqlite3_prepare_v2(database, utf8InsertQuery, -1, &statement, NULL);
        
//        https://www.sqlite.org/c3ref/step.html
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
//            https://www.sqlite.org/c3ref/reset.html
            sqlite3_reset(statement);
            return YES;
        } else {
            sqlite3_reset(statement);
            return NO;
        }
        
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return NO;
    }
}

- (NSArray *)retrieveAllUndergrads {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *querySQL = @"select * from undergraduate_details_table";
        
        const char *utf8QuerySQL = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(database, utf8QuerySQL, -1, &statement, NULL) == SQLITE_OK) {
            
            NSMutableArray *personArr = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
//              https://www.sqlite.org/c3ref/column_count.html
                int totalColumns = sqlite3_column_count(statement);
                
                UndergraduateObj *undergrad = [UndergraduateObj alloc];
                
                NSString *uName;
                NSString *uUniId;
                NSString *uGpa;
                
                for (int i=0; i<totalColumns; i++){
                    
//                  https://www.sqlite.org/c3ref/column_blob.html
                    char *dbDataAsChars = (char *)sqlite3_column_text(statement, i);

                    if (dbDataAsChars != NULL) {
                        
                        switch (i) {
                            case 0:
                                uName = [NSString  stringWithUTF8String:dbDataAsChars];
                                break;
                            case 1:
                                uUniId = [NSString  stringWithUTF8String:dbDataAsChars];
                                break;
                            case 2:
                                uGpa = [NSString  stringWithUTF8String:dbDataAsChars];
                                break;
                                
                            default:
                                break;
                        }
                    }
                }
                
                undergrad.undergradName = uName;
                undergrad.undergradUniId = uUniId;
                undergrad.undergradGpa = uGpa;
                
                [personArr addObject:undergrad];
            }
            
            sqlite3_reset(statement);
            
            return [personArr copy];
            
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_prepare_v2 is NOT ok", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return nil;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        return nil;
    }
    
    return nil;
}

- (BOOL)updateName:(NSString *)name uniId:(NSString *)uniId gpa:(NSString *)gpa {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *updateQuery = [NSString stringWithFormat:@"update undergraduate_details_table set undergraduate_name_column='%@', undergraduate_gpa_column=%f where undergraduate_uni_id_column='%@'", name, [gpa doubleValue], uniId];
        
        const char *utf8UpdateQuery = [updateQuery UTF8String];
        
        sqlite3_prepare_v2(database, utf8UpdateQuery, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            sqlite3_reset(statement);
            return YES;
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_step != SQLITE_DONE", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return NO;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        sqlite3_reset(statement);
        return NO;
    }
}

- (BOOL)deleteUnderGrad:(NSString *)uniId {
    if (debugEnable) NSLog(@"%s - %d", __PRETTY_FUNCTION__, __LINE__);
    
    const char *utf8Dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(utf8Dbpath, &database) == SQLITE_OK) {
        
        NSString *deleteQuery = [NSString stringWithFormat:@"delete from undergraduate_details_table where undergraduate_uni_id_column='%@'", uniId];
        
        const char *utf8DeleteQuery = [deleteQuery UTF8String];
        
        sqlite3_prepare_v2(database, utf8DeleteQuery, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            sqlite3_reset(statement);
            return YES;
        } else {
            if (debugEnable) NSLog(@"%s - %d # sqlite3_step != SQLITE_DONE", __PRETTY_FUNCTION__, __LINE__);
            sqlite3_reset(statement);
            return NO;
        }
    } else {
        if (debugEnable) NSLog(@"%s - %d # Fail to open DB", __PRETTY_FUNCTION__, __LINE__);
        sqlite3_reset(statement);
        return NO;
    }
}

























@end
