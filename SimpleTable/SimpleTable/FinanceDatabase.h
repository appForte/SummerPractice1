//
//  FinanceDatabase.h
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Quote.h"

@interface FinanceDatabase : NSObject
{
    sqlite3 *_database;
}
+ (FinanceDatabase*)initDatabase;
- (NSMutableArray *)financialInfosFor:(NSString*)what;
-(void)insertFinData:(Quote*)quote;
-(void)deleteFindatas;
- (MyDate *)getDateOnlyFor:(NSString*)what;
@end
