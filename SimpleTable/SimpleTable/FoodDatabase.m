//
//  FoodDatabase.m
//  SimpleTable
//
//  Created by Tekla on 01/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "FoodDatabase.h"
#import "STFood.h"

@implementation FoodDatabase
static FoodDatabase *_database;

+ (FoodDatabase*)initDatabase
{
    if (_database == nil)
    {
        _database = [[FoodDatabase alloc] init];
    }
    return _database;
}


- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


- (id)init
{
    if ((self = [super init]))
    {
       
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString * path = [[NSString alloc]initWithString:[documentsDirectory stringByAppendingPathComponent:@"foodlist.sqlite3"]];
        
        //path = [[NSBundle mainBundle] pathForResource:@"foodlist" ofType:@"sqlite3"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path] == FALSE)
        {
            NSLog(@"Creating new database.\n");
        }
        
        
        if (sqlite3_open([path UTF8String], &_database) == SQLITE_OK)
        {
            const char *sqlStatement = "CREATE TABLE IF NOT EXISTS FOODS (ind number, name TEXT, imageName TEXT)";
            char *error;
            sqlite3_exec(_database, sqlStatement, NULL, NULL, &error);
            
        }
        else
        {
            NSLog(@"Failed to create/open database!\n");
        }
        
        
        
        /*if (sqlite3_open([path UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }*/
    }
    
    return self;
}

- (NSMutableArray *)foodInfos
{
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = @"SELECT ind, name, imageName FROM foods ORDER BY name";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int ind = sqlite3_column_int(statement, 0);
            char *nameChars = (char *) sqlite3_column_text(statement, 1);
            char *imageNameChars = (char *) sqlite3_column_text(statement, 2);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChars];
            NSString *imageName = [[NSString alloc] initWithUTF8String:imageNameChars];
            
            STFood * food = [[STFood alloc] init];
            food.ind=ind;
            food.name=name;
            food.imageName=imageName;
            
            [retval addObject:food];
        }
        sqlite3_finalize(statement);
        
    }
    return retval;
}
-(void)insertFood:(STFood*)food
{
    NSString *stmt = [NSString stringWithFormat:@"INSERT INTO foods values ('%i','%@','%@')"
                      , food.ind,food.name,food.imageName];
    sqlite3_stmt *statement;
    if (sqlite3_exec(_database, [stmt UTF8String], NULL, &statement, NULL)== SQLITE_OK)
    {   NSLog(@"1 row inserted.\n");
    }
    else
    {
        NSLog(@"Insert error.\n");
    }
    //sqlite3_finalize(statement);
}
- (void)dealloc
{
    sqlite3_close(_database);
    
}

@end
