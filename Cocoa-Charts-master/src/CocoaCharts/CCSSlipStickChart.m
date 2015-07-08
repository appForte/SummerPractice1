//
//  CCSSlipStickChart.m
//  CocoaChartsSample
//
//  Created by limc on 11/21/13.
//  Copyright (c) 2013 limc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "CCSSlipStickChart.h"
#import "CCSStickChartData.h"

@interface  CCSSlipStickChart () {
    CGFloat _startDistance1;
    CGFloat _minDistance1;
    CGFloat _doubleTouchInterval;
    int _flag;
    CGFloat _firstX;
}
@end

@implementation CCSSlipStickChart
@synthesize displayNumber = _displayNumber;
@synthesize displayFrom = _displayFrom;
@synthesize minDisplayNumber = _minDisplayNumber;
@synthesize zoomBaseLine = _zoomBaseLine;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _startDistance1 = 0;
        _minDistance1 = 8;
        _doubleTouchInterval = 100;
        _flag = 1;
        _firstX = 0;
    }
    return self;
}

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];
    
    self.displayFrom = 0;
    self.displayNumber = 10;
    self.minDisplayNumber = 20;
    self.zoomBaseLine = CCSStickZoomBaseLineCenter;
}

- (void)calcDataValueRange {
    double maxValue = 0;
    double minValue = NSIntegerMax;
    
    CCSStickChartData *first = [self.stickData objectAtIndex:self.displayFrom];
    //第一个stick为停盘的情况
    if (first.high == 0 && first.low == 0) {
        
    } else {
        maxValue = first.high;
        minValue = first.low;
    }
    
    //判断显示为方柱或显示为线条
    for (NSUInteger i = self.displayFrom; i < self.displayFrom + self.displayNumber; i++) {
        CCSStickChartData *stick = [self.stickData objectAtIndex:i];
        if (stick.low < minValue) {
            minValue = stick.low;
        }
        
        if (stick.high > maxValue) {
            maxValue = stick.high;
        }
        
    }
    
    self.maxValue = maxValue;
    self.minValue = minValue;
}

- (void)initAxisX {
    if (self.stickData == nil) {
        return;
    }
    if([self.stickData count] == 0){
        return;
    }
    NSMutableArray *TitleX = [[[NSMutableArray alloc] init] autorelease];
    CGFloat average = self.displayNumber / self.longitudeNum;
    CCSStickChartData *chartdata = nil;
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        //处理刻度
        for (NSUInteger i = 0; i < self.longitudeNum; i++) {
            NSUInteger index = self.displayFrom + (NSUInteger) floor(i * average);
            if (index > self.displayFrom + self.displayNumber - 1) {
                index = self.displayFrom + self.displayNumber - 1;
            }
            chartdata = [self.stickData objectAtIndex:index];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
        }
        chartdata = [self.stickData objectAtIndex:self.displayFrom + self.displayNumber - 1];
        //追加标题
        [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
    }
    else {
        //处理刻度
        for (NSUInteger i = 0; i < self.longitudeNum; i++) {
            NSUInteger index = self.displayFrom + (NSUInteger) floor(i * average);
            if (index > self.displayFrom + self.displayNumber - 1) {
                index = self.displayFrom + self.displayNumber - 1;
            }
            chartdata = [self.stickData objectAtIndex:index];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
        }
        chartdata = [self.stickData objectAtIndex:self.displayFrom + self.displayNumber - 1];
        //追加标题
        [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
    }
    
    self.longitudeTitles = TitleX;
}

- (void)initAxisY {
    //计算取值范围
    [self calcValueRange];
    
    if (self.maxValue == 0. && self.minValue == 0.) {
        self.latitudeTitles = nil;
        return;
    }
    
    NSMutableArray *TitleY = [[[NSMutableArray alloc] init]autorelease];
    CGFloat average = (NSUInteger) ((self.maxValue - self.minValue) / self.latitudeNum);
    //处理刻度
    for (NSUInteger i = 0; i < self.latitudeNum; i++) {
        if (self.axisCalc == 1) {
            NSUInteger degree = floor(self.minValue + i * average) / self.axisCalc;
            NSString *value = [[NSNumber numberWithUnsignedInteger:degree]stringValue];
            [TitleY addObject:value];
        } else {
            NSString *value = [NSString stringWithFormat:@"%-.2f", floor(self.minValue + i * average) / self.axisCalc];
            [TitleY addObject:value];
        }
    }
    //处理最大值
    if (self.axisCalc == 1) {
        NSUInteger degree = (NSInteger) (self.maxValue) / self.axisCalc;
        NSString *value = [[NSNumber numberWithUnsignedInteger:degree]stringValue];
        [TitleY addObject:value];
    }
    else {
        NSString *value = [NSString stringWithFormat:@"%-.2f", (self.maxValue) / self.axisCalc];
        [TitleY addObject:value];
    }
    
    self.latitudeTitles = TitleY;
}

- (NSString *)calcAxisXGraduate:(CGRect)rect {
    if (self.stickData == nil) {
        return @"";
    }
    if([self.stickData count] == 0){
        return @"";
    }
    CGFloat value = [self touchPointAxisXValue:rect];
    NSString *result = @"";
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            if (value >= 1) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:self.displayFrom + self.displayNumber - 1]).date;
            } else if (value <= 0) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:self.displayFrom]).date;
            } else {
                NSUInteger index = self.displayFrom + (NSUInteger) (self.displayNumber * value);
                if (index > self.displayFrom + self.displayNumber - 1) {
                    index = self.displayFrom + self.displayNumber - 1;
                }
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:index]).date;
            }
        } else {
            if (value >= 1) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:self.displayFrom + self.displayNumber - 1]).date;
            } else if (value <= 0) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:self.displayFrom]).date;
            } else {
                NSUInteger index = self.displayFrom + (NSUInteger) (self.displayNumber * value);
                if (index > self.displayFrom + self.displayNumber - 1) {
                    index = self.displayFrom + self.displayNumber - 1;
                }
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:index]).date;
            }
        }
    return result;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        
        if (_flag == 0) {
            _firstX = pt1.x;
        } else {
            if (fabs(pt1.x - self.singleTouchPoint.x) < 10) {
                self.displayCrossXOnTouch = NO;
                self.displayCrossYOnTouch = NO;
                [self setNeedsDisplay];
                self.singleTouchPoint = CGPointZero;
                _flag = 0;
                
            } else {
                //获取选中点
                self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
                //重绘
                self.displayCrossXOnTouch = YES;
                self.displayCrossYOnTouch = YES;
                [self setNeedsDisplay];
                
                _flag = 1;
            }
        }
        
    } else if ([allTouches count] == 2) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];
        
        _startDistance1 = fabsf(pt1.x - pt2.x);
    } else {
        
    }
    
    //调用父类的触摸事件
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {
        if (_flag == 0) {
            CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
            CGFloat stickWidth = ([self dataQuadrantPaddingWidth:self.frame]/ self.displayNumber) - 1;
            
            if (pt1.x - _firstX > stickWidth) {
                if (self.displayFrom > 2) {
                    self.displayFrom = self.displayFrom - 2;
                }
            } else if (pt1.x - _firstX < -stickWidth) {
                if (self.displayFrom + self.displayNumber + 2 < [self.stickData count]) {
                    self.displayFrom = self.displayFrom + 2;
                }
            }
            
            _firstX = pt1.x;
            
            [self setNeedsDisplay];
            //设置可滚动
            //[self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
            
            if (self.coChart) {
                ((CCSSlipStickChart *)self.coChart).displayFrom = self.displayFrom;
                ((CCSSlipStickChart *)self.coChart).displayNumber = self.displayNumber;
                [self.coChart setNeedsDisplay];
            }
        } else {
            //获取选中点
            self.singleTouchPoint = [[allTouches objectAtIndex:0] locationInView:self];
            //设置可滚动
            //[self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
            [self setNeedsDisplay];
        }
        //        }
    } else if ([allTouches count] == 2) {
        CGPoint pt1 = [[allTouches objectAtIndex:0] locationInView:self];
        CGPoint pt2 = [[allTouches objectAtIndex:1] locationInView:self];
        
        CGFloat endDistance = fabsf(pt1.x - pt2.x);
        //放大
        if (endDistance - _startDistance1 > _minDistance1) {
            [self zoomOut];
            _startDistance1 = endDistance;
            
            [self setNeedsDisplay];
        } else if (endDistance - _startDistance1 < -_minDistance1) {
            [self zoomIn];
            _startDistance1 = endDistance;
            
            [self setNeedsDisplay];
        }
        
    } else {
        
    }
    
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesEnded:touches withEvent:event];
    
    _startDistance1 = 0;
    
    _flag = 1;
    
    [self setNeedsDisplay];
}

- (void)drawData:(CGRect)rect {
    if (self.stickData == nil) {
        return;
    }
    if([self.stickData count] == 0){
        return;
    }
    // 蜡烛棒宽度
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.displayNumber) - 1;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, self.stickBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.stickFillColor.CGColor);
    
    
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        // 蜡烛棒起始绘制位置
        CGFloat stickX = [self dataQuadrantPaddingStartX:rect] + 1;
        //判断显示为方柱或显示为线条
        for (NSUInteger i = self.displayFrom; i < self.displayFrom + self.displayNumber; i++) {
            CCSStickChartData *stick = [self.stickData objectAtIndex:i];
            
            CGFloat highY = [self calcValueY:stick.high inRect:rect];
            CGFloat lowY = [self calcValueY:stick.low inRect:rect];
            
            if (stick.high == 0) {
                //没有值的情况下不绘制
            } else {
                //绘制数据，根据宽度判断绘制直线或方柱
                if (stickWidth >= 2) {
                    CGContextAddRect(context, CGRectMake(stickX, highY, stickWidth, lowY - highY));
                    //填充路径
                    CGContextFillPath(context);
                } else {
                    CGContextMoveToPoint(context, stickX, highY);
                    CGContextAddLineToPoint(context, stickX, lowY);
                    //绘制线条
                    CGContextStrokePath(context);
                }
            }
            
            //X位移
            stickX = stickX + 1 + stickWidth;
        }
    } else {
        // 蜡烛棒起始绘制位置
        CGFloat stickX = [self dataQuadrantPaddingEndX:rect] - 1 - stickWidth;
        //判断显示为方柱或显示为线条
        for (NSUInteger i = 0; i < self.displayNumber; i++) {
            //获取index
            NSUInteger index = self.displayFrom + self.displayNumber - 1 - i;
            CCSStickChartData *stick = [self.stickData objectAtIndex:index];
            
            CGFloat highY = [self calcValueY:stick.high inRect:rect];
            CGFloat lowY = [self calcValueY:stick.low inRect:rect];
            
            if (stick.high == 0) {
                //没有值的情况下不绘制
            } else {
                //绘制数据，根据宽度判断绘制直线或方柱
                if (stickWidth >= 2) {
                    CGContextAddRect(context, CGRectMake(stickX, highY, stickWidth, lowY - highY));
                    //填充路径
                    CGContextFillPath(context);
                } else {
                    CGContextMoveToPoint(context, stickX, highY);
                    CGContextAddLineToPoint(context, stickX, lowY);
                    //绘制线条
                    CGContextStrokePath(context);
                }
            }
            //X位移
            stickX = stickX - 1 - stickWidth;
        }
    }
    
}

- (void)drawLongitudeLines:(CGRect)rect {
    if (self.displayLongitude == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    //设置线条为点线
    if (self.dashLongitude) {
        CGFloat lengths[] = {3.0, 3.0};
        CGContextSetLineDash(context, 0.0, lengths, 2);
    }
    
    CGFloat postOffset,offset;
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.displayNumber);
    if (self.stickAlignType == CCSStickAlignTypeCenter) {
        postOffset= ([self dataQuadrantPaddingWidth:rect] - stickWidth) / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect] + stickWidth/2;
    }else{
        postOffset= [self dataQuadrantPaddingWidth:rect] / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect];
    }
    
    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
        CGContextMoveToPoint(context, offset + i * postOffset, [self dataQuadrantStartY:rect]);
        CGContextAddLineToPoint(context, offset + i * postOffset, [self dataQuadrantEndY:rect]);
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, nil, 0);
}

- (void)drawXAxisTitles:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    if (self.displayLongitude == NO) {
        return;
    }
    
    if (self.displayLongitudeTitle == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    
    CGFloat postOffset,offset;
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.displayNumber);
    if (self.stickAlignType == CCSStickAlignTypeCenter) {
        postOffset= ([self dataQuadrantPaddingWidth:rect] - stickWidth) / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect] + stickWidth/2;
    }else{
        postOffset= [self dataQuadrantPaddingWidth:rect] / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect];
    }
    
    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
        CGFloat startY;
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            startY = [self dataQuadrantEndY:rect] + [self axisWidth];
        }else{
            startY = [self borderWidth];
        }
        
        NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
        
        //调整X轴坐标位置
        if (i == 0) {
            [str drawInRect:CGRectMake([self dataQuadrantPaddingStartX:rect], startY, postOffset, self.longitudeFontSize)
                   withFont:self.longitudeFont
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentLeft];
            
        } else if (i == [self.longitudeTitles count] - 1) {
            if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
                [str drawInRect:CGRectMake(rect.size.width - postOffset, startY, postOffset, self.longitudeFontSize)
                       withFont:self.longitudeFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentRight];
            } else {
                [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, startY, postOffset, self.longitudeFontSize)
                       withFont:self.longitudeFont
                  lineBreakMode:NSLineBreakByWordWrapping
                      alignment:NSTextAlignmentCenter];
            }
            
        } else {
            [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, startY, postOffset, self.longitudeFontSize)
                   withFont:self.longitudeFont
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
        }
    }
}

- (void)calcSelectedIndex {
    //X在系统范围内、进行计算
    if (self.singleTouchPoint.x > [self dataQuadrantPaddingStartX:self.frame]
        && self.singleTouchPoint.x < [self dataQuadrantPaddingEndX:self.frame]) {
        CGFloat stickWidth = ([self dataQuadrantPaddingWidth:self.frame] / self.displayNumber);
        CGFloat valueWidth = self.singleTouchPoint.x - [self dataQuadrantPaddingStartX:self.frame];
        if (valueWidth > 0) {
            NSUInteger index = (NSUInteger) (valueWidth / stickWidth);
            //如果超过则设置位最大
            if (index >= self.displayNumber) {
                index = self.displayNumber - 1;
            }
            //设置选中的index
            self.selectedStickIndex = self.displayFrom + index;
        }
    }
}

- (void)zoomOut {
    if (self.displayNumber > self.minDisplayNumber) {
        
        //区分缩放方向
        if (self.zoomBaseLine == CCSStickZoomBaseLineCenter) {
            self.displayNumber = self.displayNumber - 2;
            self.displayFrom = self.displayFrom + 1;
        } else if (self.zoomBaseLine == CCSStickZoomBaseLineLeft) {
            self.displayNumber = self.displayNumber - 2;
        } else if (self.zoomBaseLine == CCSStickZoomBaseLineRight) {
            self.displayNumber = self.displayNumber - 2;
            self.displayFrom = self.displayFrom + 2;
        }
        
        //处理displayNumber越界
        if (self.displayNumber < self.minDisplayNumber) {
            self.displayNumber = self.minDisplayNumber;
        }
        
        //处理displayFrom越界
        if (self.displayFrom + self.displayNumber >= [self.stickData count]) {
            self.displayFrom = [self.stickData count] - self.displayNumber;
        }
        
        if (self.coChart) {
            ((CCSSlipStickChart *)self.coChart).displayFrom = self.displayFrom;
            ((CCSSlipStickChart *)self.coChart).displayNumber = self.displayNumber;
            [self.coChart setNeedsDisplay];
        }
    }
}

- (void)zoomIn {
    if (self.displayNumber < [self.stickData count] - 1) {
        if (self.displayNumber + 2 > [self.stickData count] - 1) {
            self.displayNumber = [self.stickData count] - 1;
            self.displayFrom = 0;
        } else {
            //区分缩放方向
            if (self.zoomBaseLine == CCSStickZoomBaseLineCenter) {
                self.displayNumber = self.displayNumber + 2;
                if (self.displayFrom > 1) {
                    self.displayFrom = self.displayFrom - 1;
                } else {
                    self.displayFrom = 0;
                }
            } else if (self.zoomBaseLine == CCSStickZoomBaseLineLeft) {
                self.displayNumber = self.displayNumber + 2;
            } else if (self.zoomBaseLine == CCSStickZoomBaseLineRight) {
                self.displayNumber = self.displayNumber + 2;
                if (self.displayFrom > 2) {
                    self.displayFrom = self.displayFrom - 2;
                } else {
                    self.displayFrom = 0;
                }
            }
        }
        
        if (self.displayFrom + self.displayNumber >= [self.stickData count]) {
            self.displayNumber = [self.stickData count] - self.displayFrom;
        }
        
        if (self.coChart) {
            ((CCSSlipStickChart *)self.coChart).displayFrom = self.displayFrom;
            ((CCSSlipStickChart *)self.coChart).displayNumber = self.displayNumber;
            [self.coChart setNeedsDisplay];
        }
    }
}

- (void) setDisplayFrom:(NSUInteger)displayFrom
{
    _displayFrom = displayFrom;
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartDisplayChangedFrom:number:)]) {
        [self.chartDelegate CCSChartDisplayChangedFrom:displayFrom number:self.displayNumber];
    }
}

-(void) setDisplayNumber:(NSUInteger)displayNumber
{
    _displayNumber = displayNumber;
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartDisplayChangedFrom: number:)]) {
        [self.chartDelegate CCSChartDisplayChangedFrom:self.displayFrom number:displayNumber];
    }
}

@end
