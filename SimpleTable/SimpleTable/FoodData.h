//
//  FoodData.h
//  SimpleTable
//
//  Created by Tekla on 30/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFood.h"

@interface FoodData : NSObject
{
    NSMutableArray *dataArray;
    NSArray *init;
}
+(FoodData*)initialize;
-(void)addFood:(STFood *)food;
-(int)getNumOfFoods;
-(STFood*)getFoodByName:(NSString*)name;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end
