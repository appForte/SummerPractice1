//
//  Quote.h
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDate.h"

@interface Quote : NSObject
{
    MyDate  *date;
    NSString *name;
    double open, high, low, close, volume, adjClose;
}
-(id)init;
@property (nonatomic,strong) MyDate *date;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) double open,high,low,close,volume,adjClose;
@end
