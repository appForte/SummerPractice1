//
//  FinanceDatabase.m
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "FinanceDatabase.h"


@implementation FinanceDatabase
static FinanceDatabase *_database;

+ (FinanceDatabase*)initDatabase
{
    if (_database == nil)
    {
        _database = [[FinanceDatabase alloc] init];
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
            const char *sqlStatement;
            char *error;
            sqlStatement="CREATE TABLE IF NOT EXISTS FINDATAS (finDataName TEXT, date TEXT, open REAL, high REAL, low REAL, close REAL, volume REAL, adjClose REAL)";
            
            sqlite3_exec(_database, sqlStatement, NULL, NULL, &error);
            
        }
        else
        {
            NSLog(@"Failed to create/open database!\n");
        }
        
        
    }
    
    return self;
}
- (NSMutableArray *)financialInfosFor:(NSString*)what
{
    NSMutableArray *retval = [[NSMutableArray alloc] init] ;
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM findatas WHERE finDataName = '%@' ORDER BY date  DESC " ,what];
    //NSString *query = @"SELECT * FROM findatas ORDER BY date DESC ";
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *nameChr = (char *) sqlite3_column_text(statement, 0);
            char *dateChr = (char *) sqlite3_column_text(statement, 1);
            double open =  sqlite3_column_double(statement, 2);
            double high = sqlite3_column_double(statement, 3);
            double low = sqlite3_column_double(statement,4);
            double close = sqlite3_column_double(statement,5);
            double volume = sqlite3_column_double(statement,6);
            double adjClose = sqlite3_column_double(statement,7);
            NSString *name = [[NSString alloc] initWithUTF8String:nameChr];
            NSString *date = [[NSString alloc] initWithUTF8String:dateChr];
            Quote *quote = [[Quote alloc] init];
            quote.name=name;
            quote.date=[MyDate makeDateFromString:date];
            quote.open=open;
            quote.high=high;
            quote.low=low;
            quote.close=close;
            quote.volume=volume;
            quote.adjClose=adjClose;
            
            
            
            [retval addObject:quote];
        }
        sqlite3_finalize(statement);
        
    }
    return retval;
}
- (MyDate *)getDateOnlyFor:(NSString*)what
{
    
    NSString *query = [NSString stringWithFormat:@"SELECT date FROM findatas WHERE finDataName = '%@' ORDER BY date DESC LIMIT 1" ,what];
    sqlite3_stmt *statement;
    MyDate *date=[[MyDate alloc] init ];
    date.year=[[MyDate getDate:YEAR] intValue]-1;
    date.month=[[MyDate getDate:MONTH] intValue];
    date.day=[[MyDate getDate:DAY] intValue];
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            char *dateChr = (char *) sqlite3_column_text(statement, 0);
            NSString *dateSTR = [[NSString alloc] initWithUTF8String:dateChr];
            date=[MyDate makeDateFromString:dateSTR];
            
            
        }
        sqlite3_finalize(statement);
        
    }
    return date;
}
-(void)insertFinData:(Quote*)quote
{    NSString* formattedDate;
    if(quote.date.day>=1&&quote.date.day<=9)
    {   formattedDate = [NSString stringWithFormat:@"%i-%i-0%i",quote.date.year,quote.date.month,quote.date.day];
        if(quote.date.month>=1&&quote.date.month<=9)
        {
            formattedDate = [NSString stringWithFormat:@"%i-0%i-0%i",quote.date.year,quote.date.month,quote.date.day];
        }
    }
    else
    {
        formattedDate = [NSString stringWithFormat:@"%i-%i-%i",quote.date.year,quote.date.month,quote.date.day];
        if(quote.date.month>=1&&quote.date.month<=9)
        {
            formattedDate = [NSString stringWithFormat:@"%i-0%i-%i",quote.date.year,quote.date.month,quote.date.day];
        }
    }
    NSString *stmt = [NSString stringWithFormat:@"INSERT INTO findatas (finDataName, date, open, high, low, close, volume, adjClose) values ('%@','%@','%lf','%lf','%lf','%lf','%lf','%lf')", quote.name, formattedDate, quote.open, quote.high, quote.low, quote.close, quote.volume, quote.adjClose ];
    sqlite3_stmt *statement;
    
    if (sqlite3_exec(_database, [stmt UTF8String], NULL, &statement, NULL)== SQLITE_OK)
    {  
        
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
-(void)deleteFindatasFor:(NSString*)what
{
    
    
    NSString *stmt = [NSString stringWithFormat:@"DELETE FROM findatas WHERE finDataName = '%@' ",what];
    
    sqlite3_stmt *statement;
    if (sqlite3_exec(_database, [stmt UTF8String], NULL, &statement, NULL)== SQLITE_OK)
    {   NSLog(@"Row deleted.\n");
    }
    else
    {   NSLog(@"Delete error.\n");
    }
}
-(int)rowCountFor:(NSString*)what onDate:(MyDate*)date
{   int numOfRows=0;
     NSString *stmt;
    
    if(date.day>=1&&date.day<=9)
    {
        stmt = [NSString stringWithFormat:@"SELECT * FROM findatas WHERE finDataName = '%@' AND date = '%i-%i-0%i' ",what,date.year,date.month,date.day];
        if(date.month>=1&&date.month<=9)
        {
            stmt = [NSString stringWithFormat:@"SELECT * FROM findatas WHERE finDataName = '%@' AND date = '%i-0%i-0%i' ",what,date.year,date.month,date.day];
        }
    }
    else
    {
        stmt = [NSString stringWithFormat:@"SELECT * FROM findatas WHERE finDataName = '%@' AND date = '%i-%i-%i' ",what,date.year,date.month,date.day];
        if(date.month>=1&&date.month<=9)
        {
            stmt = [NSString stringWithFormat:@"SELECT * FROM findatas WHERE finDataName = '%@' AND date = '%i-0%i-%i' ",what,date.year,date.month,date.day];
        }
    }
    
   
    sqlite3_stmt *statement;
    NSLog(@"%@",stmt);
    
    
    if (sqlite3_prepare_v2(_database, [stmt UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            numOfRows++;
            NSLog(@"Row:%i\n",numOfRows);
            
        }
        sqlite3_finalize(statement);
        
    }
    return numOfRows;
}
@end
