//
//  CCSCandleStickViewController.h
//  Cocoa-Charts
//
//  Created by limc on 13-05-22.
//  Copyright (c) 2012 limc.cn All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSCandleStickViewController : UIViewController
{
    NSMutableArray *candlestickData;
}
-(void)initWithData:(NSMutableArray*)stickData;
@end
