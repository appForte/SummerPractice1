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
+(NSString*)getDate:(DATE_OPTION)option
{   NSDate *currentDate = [[NSDate alloc] init];
    
    NSString *localDateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch(option)
    {
        case 1:
        {
            [dateFormatter setDateFormat:@"yyyy"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
        case 2:
        {
            [dateFormatter setDateFormat:@"MM"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
        default:
        {
            [dateFormatter setDateFormat:@"dd"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
    }
    
    
    return localDateString;
    
}
@end
