//
//  Quote.m
//  SimpleTable
//
//  Created by Tekla on 07/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "Quote.h"

@implementation Quote
-(id)init
{
    self=[super init];
    date = [[MyDate alloc] init];
    return self;
}
@synthesize date;
@synthesize name;
@synthesize open, high, low, close, volume, adjClose;
@end
