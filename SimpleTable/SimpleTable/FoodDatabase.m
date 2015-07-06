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
            const char *sqlStatement = "CREATE TABLE IF NOT EXISTS FOODS (ind integer PRIMARY KEY, name TEXT, imageName TEXT)";
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
    NSString *query = @"SELECT ind, name, imageName FROM foods";
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
    NSString *stmt = [NSString stringWithFormat:@"INSERT INTO foods (name, imageName) values ('%@','%@')"
                      ,food.name,food.imageName];
    sqlite3_stmt *statement;
    
    if (sqlite3_exec(_database, [stmt UTF8String], NULL, &statement, NULL)== SQLITE_OK)
    {   NSLog(@"Food with id:%i inserted.\n",food.ind);
        
        /*NSNumber *state = [NSNumber numberWithInteger:0];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * key = [[NSString alloc] initWithFormat:@"%i",food.ind];
        [defaults setObject:state forKey:key];
        
        // nem kell defaults
        [defaults synchronize]; */
    }
    else
    {
        NSLog(@"Insert error.\n");
    }
    //sqlite3_finalize(statement);
}
-(void)deleteFood:(int)foodID
{
    
    
    NSString *stmt = [NSString stringWithFormat:@"DELETE FROM foods WHERE ind = '%i'"
                      , foodID];
    
    sqlite3_stmt *statement;
    if (sqlite3_exec(_database, [stmt UTF8String], NULL, &statement, NULL)== SQLITE_OK)
    {   NSLog(@"Row deleted.\n");
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * key =@"favouriteFoods";
        NSMutableArray * favouriteFoods = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
        NSNumber * foodToDelete = [NSNumber numberWithInteger:foodID];
        
        if ([favouriteFoods containsObject: foodToDelete])
        {
            [favouriteFoods removeObject:foodToDelete];
        }
        [defaults setObject:favouriteFoods forKey:key];
        /*NSString * key = [[NSString alloc] initWithFormat:@"%i",foodID];
        [defaults removeObjectForKey:key];
        [defaults synchronize]; */
        [defaults synchronize];
        
        
    }
    else
    {
        NSLog(@"Delete error.\n");
    }
}
- (void)dealloc
{
    sqlite3_close(_database);
    
}

@end
