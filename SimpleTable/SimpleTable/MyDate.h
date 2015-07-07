//
//  MyDate.h
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDate : NSObject
{   int year,month,day;
}
@property (nonatomic,assign)int year,month,day;
+(MyDate*)makeDateFromString:(NSString*)dateStr;
-(BOOL)isBiggerThan:(MyDate*)dateComp;
@end
