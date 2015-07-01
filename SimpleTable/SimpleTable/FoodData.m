//
//  FoodData.m
//  SimpleTable
//
//  Created by Tekla on 30/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "FoodData.h"
#import "STFood.h"
static FoodData * sharedInstance;

@interface FoodData ()

@end

@implementation FoodData
@synthesize dataArray;
+(FoodData*)initialize
{   @synchronized(self)
    {   /*STFood * food1 = [[STFood alloc] init];
        STFood * food2 = [[STFood alloc] init];
        
        food1.name=@"Egg Benedict";
        food2.name=@"Mushroom Risotto"; */
        if (sharedInstance==nil)
        {
           sharedInstance = [[FoodData alloc ] init];
           //sharedInstance->init=[[NSArray alloc] initWithObjects:food1,food2,nil];
            sharedInstance->dataArray = [NSMutableArray array] ;//]WithArray:sharedInstance->init];
           /*for (id object in sharedInstance->init)
           {
               [sharedInstance->dataArray addObject:object];
               STFood *element = (STFood *) object;
               NSLog(@"Object:%@",(STFood *)element.name);
           }*/
            
            NSArray* temp = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
            int tempNumOfElements=[temp count];
            for(int i=0;i<tempNumOfElements;i++)
            {   STFood * food =[[STFood alloc] init];
                food.name=[temp objectAtIndex:i];
                food.imageName=@"creme_brelee.jpg";
                food.ind=i;
                [sharedInstance->dataArray addObject:(id)food];
                
                
            }
        
        }
    }
    return sharedInstance;
}
-(void)addFood:(STFood *)food
{
    [dataArray addObject:(id)food ];
    
}
-(int)getNumOfFoods
{   return [dataArray count];
    
}
-(STFood*)getFoodByName:(NSString *)name
{
    for (id object in dataArray)
    {
        if ([object isKindOfClass:[STFood class]])
        {
            STFood *element = (STFood *) object;
            NSLog(@"Object:%@",(STFood *)element.name);
            if([element.name isEqualToString:name])
            {   return element;
            }
            
        }
    }
    return nil;
}




@end
