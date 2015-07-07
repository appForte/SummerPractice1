//
//  MyDate.m
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "MyDate.h"

@implementation MyDate
@synthesize year,month,day;
+(MyDate*)makeDateFromString:(NSString*)dateStr
{
    MyDate * date = [[MyDate alloc] init];
    NSArray* dateComponents = [dateStr componentsSeparatedByString:@"-"];
    
    date.year = [[dateComponents objectAtIndex:0] intValue];
    date.month = [[dateComponents objectAtIndex:1] intValue];
    date.day = [[dateComponents objectAtIndex:2] intValue];
    return date;
}
-(BOOL)isBiggerThan:(MyDate*)dateComp
{   BOOL result = NO;
    if(self.year>dateComp.year)
    {
        result=YES;
        
    }
    else
    {
        if(self.year==dateComp.year)
        {
            if(self.month>dateComp.month)
            {
                result=YES;
            }
            else
            {
                if(self.month==dateComp.month)
                {
                    if(self.day>dateComp.day)
                    {
                        result=YES;
                    }
                }
            }
        }
    }
    return result;
    
}
@end
