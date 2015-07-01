//
//  FoodDatabase.h
//  SimpleTable
//
//  Created by Tekla on 01/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "STFood.h"
@interface FoodDatabase : NSObject
{
    sqlite3 *_database;
}
+ (FoodDatabase*)initDatabase;
- (NSMutableArray *)foodInfos;
-(void)insertFood:(STFood*)food;
@end
