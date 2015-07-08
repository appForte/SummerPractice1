//
//  CCSStickChart.m
//  Cocoa-Charts
//
//  Created by limc on 11-10-25.
//  Copyright 2011 limc.cn All rights reserved.
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

#import "CCSStickChart.h"
#import "CCSStickChartData.h"


@implementation CCSStickChart

@synthesize stickData = _stickData;
@synthesize stickBorderColor = _stickBorderColor;
@synthesize stickFillColor = _stickFillColor;
@synthesize latitudeNum = _latitudeNum;
@synthesize longitudeNum = _longitudeNum;
@synthesize maxSticksNum = _maxSticksNum;
@synthesize selectedStickIndex = _selectedStickIndex;
@synthesize maxValue = _maxValue;
@synthesize minValue = _minValue;
@synthesize coChart = _coChart;
@synthesize axisCalc = _axisCalc;
@synthesize stickAlignType = _stickAlignType;

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];

    self.stickBorderColor = [UIColor yellowColor];
    self.stickFillColor = [UIColor yellowColor];

    self.latitudeNum = 3;
    self.longitudeNum = 3;
    self.maxSticksNum = 26;
    self.maxValue = 100;
    self.minValue = 0;
    self.selectedStickIndex = 0;

    self.stickData = nil;
    self.coChart = nil;
    self.axisCalc = 1;
    self.stickAlignType =CCSStickAlignTypeCenter;
}

- (void)dealloc {
    [_stickData release];
    [_stickBorderColor release];
    [_stickFillColor release];
    [super dealloc];
}

- (void)calcDataValueRange {
    double maxValue = 0;
    double minValue = NSIntegerMax;

    CCSStickChartData *first = [self.stickData objectAtIndex:0];
    //第一个stick为停盘的情况
    if (first.high == 0 && first.low == 0) {

    } else {
        maxValue = first.high;
        minValue = first.low;
    }

    //判断显示为方柱或显示为线条
    for (NSUInteger i = 0; i < [self.stickData count]; i++) {
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

- (void)calcValueRangePaddingZero {

    double maxValue = self.maxValue;
    double minValue = self.minValue;

    if ((long) maxValue > (long) minValue) {
        if ((maxValue - minValue) < 10 && minValue > 1) {
            self.maxValue = (long) (maxValue + 1);
            self.minValue = (long) (minValue - 1);
        } else {
            self.maxValue = (long) (maxValue + (maxValue - minValue) * 0.1);
            self.minValue = (long) (minValue - (maxValue - minValue) * 0.1);
            if (self.minValue < 0) {
                self.minValue = 0;
            }
        }
    } else if ((long) maxValue == (long) minValue) {
        if (maxValue <= 10 && maxValue > 1) {
            self.maxValue = maxValue + 1;
            self.minValue = minValue - 1;
        } else if (maxValue <= 100 && maxValue > 10) {
            self.maxValue = maxValue + 10;
            self.minValue = minValue - 10;
        } else if (maxValue <= 1000 && maxValue > 100) {
            self.maxValue = maxValue + 100;
            self.minValue = minValue - 100;
        } else if (maxValue <= 10000 && maxValue > 1000) {
            self.maxValue = maxValue + 1000;
            self.minValue = minValue - 1000;
        } else if (maxValue <= 100000 && maxValue > 10000) {
            self.maxValue = maxValue + 10000;
            self.minValue = minValue - 10000;
        } else if (maxValue <= 1000000 && maxValue > 100000) {
            self.maxValue = maxValue + 100000;
            self.minValue = minValue - 100000;
        } else if (maxValue <= 10000000 && maxValue > 1000000) {
            self.maxValue = maxValue + 1000000;
            self.minValue = minValue - 1000000;
        } else if (maxValue <= 100000000 && maxValue > 10000000) {
            self.maxValue = maxValue + 10000000;
            self.minValue = minValue - 10000000;
        }
    } else {
        self.maxValue = 0;
        self.minValue = 0;
    }
}

- (void)calcValueRangeFormatForAxis {
    //修正最大值和最小值
    long rate = (self.maxValue - self.minValue) / (self.latitudeNum);
    NSString *strRate = [NSString stringWithFormat:@"%ld", rate];
    CGFloat first = [[strRate substringToIndex:1] intValue] + 1.0f;
    if (first > 0 && strRate.length > 1) {
        CGFloat second = [[[strRate substringToIndex:2] substringFromIndex:1] intValue];
        if (second < 5) {
            first = first - 0.5;
        }
        rate = first * pow(10, strRate.length - 1);
    } else {
        rate = 1;
    }
    //等分轴修正
    if (self.latitudeNum > 0 && (long) (self.maxValue - self.minValue) % (self.latitudeNum * rate) != 0) {
        //最大值加上轴差
        self.maxValue = (long) self.maxValue + (self.latitudeNum * rate) - ((long) (self.maxValue - self.minValue) % (self.latitudeNum * rate));
    }
}

- (void)calcValueRange {
    if (self.stickData != NULL && [self.stickData count] > 0) {

        //计算数据的真实范围
        [self calcDataValueRange];

        //计算数据的真实范围
        [self calcValueRangePaddingZero];

    } else {
        self.maxValue = 0;
        self.minValue = 0;
    }

    [self calcValueRangeFormatForAxis];
}

- (void)initAxisX {
    if (self.stickData == nil) {
        return;
    }
    if([self.stickData count] == 0){
        return;
    }
    NSMutableArray *TitleX = [[[NSMutableArray alloc] init] autorelease];
        CGFloat average = self.maxSticksNum / self.longitudeNum;
        CCSStickChartData *chartdata = nil;
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            //处理刻度
            for (NSUInteger i = 0; i < self.longitudeNum; i++) {
                NSUInteger index = (NSUInteger) floor(i * average);
                if (index > self.maxSticksNum - 1) {
                    index = self.maxSticksNum - 1;
                }
                chartdata = [self.stickData objectAtIndex:index];
                //追加标题
                [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
            }
            chartdata = [self.stickData objectAtIndex:self.maxSticksNum - 1];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
        }
        else {
            //处理刻度
            for (NSUInteger i = 0; i < self.longitudeNum; i++) {
                NSUInteger index = [self.stickData count] - self.maxSticksNum + (NSUInteger) floor(i * average);
                if (index > [self.stickData count] - 1) {
                    index = [self.stickData count] - 1;
                }
                chartdata = [self.stickData objectAtIndex:index];
                //追加标题
                [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
            }
            chartdata = [self.stickData objectAtIndex:[self.stickData count] - 1];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", chartdata.date]];
        }
    self.longitudeTitles = TitleX;
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
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.maxSticksNum);
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
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.maxSticksNum);
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

- (void)drawRect:(CGRect)rect {
    //初始化XY轴
    [self initAxisY];
    [self initAxisX];


    [super drawRect:rect];

    //绘制数据
    [self drawData:rect];
}

- (void)drawData:(CGRect)rect {
    if (self.stickData == nil) {
        return;
    }
    if([self.stickData count] == 0){
        return;
    }
    // 蜡烛棒宽度
    CGFloat stickWidth = ([self dataQuadrantPaddingWidth:rect] / self.maxSticksNum) - 1;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, self.stickBorderColor.CGColor);
    CGContextSetFillColorWithColor(context, self.stickFillColor.CGColor);


        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            // 蜡烛棒起始绘制位置
            CGFloat stickX = [self dataQuadrantPaddingStartX:rect] + 1;
            //判断显示为方柱或显示为线条
            for (NSUInteger i = 0; i < [self.stickData count]; i++) {
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
            for (NSInteger i = [self.stickData count] - 1; i >= 0; i--) {
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
                stickX = stickX - 1 - stickWidth;
            }
        }

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
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:self.maxSticksNum]).date;
            } else if (value <= 0) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:0]).date;
            } else {
                NSUInteger index = (NSUInteger) (self.maxSticksNum * value);
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:index]).date;
            }
        } else {
            if (value >= 1) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:[self.stickData count] - 1]).date;
            } else if (value <= 0) {
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:[self.stickData count] - self.maxSticksNum]).date;
            } else {
                NSUInteger index = [self.stickData count] - self.maxSticksNum + (NSUInteger) (self.maxSticksNum * value);
                if (index > [self.stickData count] - 1) {
                    index = [self.stickData count] - 1;
                }
                result = ((CCSStickChartData *) [self.stickData objectAtIndex:index]).date;
            }
        }
    return result;
}

- (NSString *)calcAxisYGraduate:(CGRect)rect {
    CGFloat value = [self touchPointAxisYValue:rect];

    if (self.maxValue == 0. && self.minValue == 0.) {
        return @"";
    }

    if (self.axisCalc == 1) {
        return [NSString stringWithFormat:@"%d", (int) ((value * (self.maxValue - self.minValue) + self.minValue) / self.axisCalc)];
    } else {
        return [NSString stringWithFormat:@"%-.2f", (value * (self.maxValue - self.minValue) + self.minValue) / self.axisCalc];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //父类的点击事件
    [super touchesBegan:touches withEvent:event];
    //计算选中的索引
    [self calcSelectedIndex];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //调用父类的触摸事件
    [super touchesMoved:touches withEvent:event];
    //计算选中的索引
    [self calcSelectedIndex];

    NSArray *allTouches = [touches allObjects];
    //处理点击事件
    if ([allTouches count] == 1) {

        CGPoint pt = CGPointMake(self.singleTouchPoint.x, self.coChart.singleTouchPoint.y);
        //获取选中点
        self.coChart.singleTouchPoint = pt;
        [self.coChart performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];

    } else if ([allTouches count] == 2) {

    } else {

    }

}

- (void)calcSelectedIndex {
    //X在系统范围内、进行计算
    if (self.singleTouchPoint.x >= [self dataQuadrantPaddingStartX:self.frame]
        && self.singleTouchPoint.x < [self dataQuadrantPaddingEndX:self.frame]) {
        CGFloat stickWidth = ([self dataQuadrantPaddingWidth:self.frame] / self.maxSticksNum);
        CGFloat valueWidth = self.singleTouchPoint.x - [self dataQuadrantPaddingStartX:self.frame] ;
        if (valueWidth > 0) {
            NSUInteger index;
            if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
                index = (NSUInteger) (valueWidth / stickWidth);
            }else{
                index = (NSUInteger) ([self.stickData count] - self.maxSticksNum + (valueWidth / stickWidth));
            }
            //如果超过则设置位最大
            if (index >= self.maxSticksNum) {
                index = self.maxSticksNum - 1;
            }
            //设置选中的index
            self.selectedStickIndex = index;
        }
    }
}

- (void)setSelectedPointAddReDraw:(CGPoint)point {
    point.y = 1;
    self.singleTouchPoint = point;
    [self calcSelectedIndex];

    [self setNeedsDisplay];
}

- (void)zoomOut {
    if ([self.stickData count] <= 50) {
        //纵屏最小20根，2根起开始变化
        if (self.maxSticksNum > 20) {
            self.maxSticksNum = self.maxSticksNum - 3;
            //固定根数
            if (self.maxSticksNum < 20) {
                self.maxSticksNum = 20;
            }
            if (self.coChart) {
                self.coChart.maxSticksNum = self.maxSticksNum;
                [self.coChart setNeedsDisplay];
            }
        }
    } else {
        //横屏最小40根，4根起开始变化
        if (self.maxSticksNum > 40) {
            self.maxSticksNum = self.maxSticksNum - 4;
            //固定根数
            if (self.maxSticksNum < 40) {
                self.maxSticksNum = 40;
            }
            if (self.coChart) {
                self.coChart.maxSticksNum = self.maxSticksNum;
                [self.coChart setNeedsDisplay];
            }
        }
    }
}

- (void)zoomIn {
    if ([self.stickData count] <= 50) {
        //2根起开始变化
        if (self.maxSticksNum < [self.stickData count] - 1) {
            if (self.maxSticksNum + 2 > [self.stickData count] - 1) {
                self.maxSticksNum = [self.stickData count] - 1;
            } else {
                self.maxSticksNum = self.maxSticksNum + 2;
            }
            if (self.coChart) {
                self.coChart.maxSticksNum = self.maxSticksNum;
                [self.coChart setNeedsDisplay];
            }
        }
    }
    else {
        //4根起开始变化
        if (self.maxSticksNum < [self.stickData count] - 1) {
            if (self.maxSticksNum + 4 > [self.stickData count] - 1) {
                self.maxSticksNum = [self.stickData count] - 1;
            } else {
                self.maxSticksNum = self.maxSticksNum + 4;
            }
            if (self.coChart) {
                self.coChart.maxSticksNum = self.maxSticksNum;
                [self.coChart setNeedsDisplay];
            }
        }
    }
}

- (void) setSingleTouchPoint:(CGPoint) point
{
    _singleTouchPoint = point;
    
    [self calcSelectedIndex];
    
    if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(CCSChartBeTouchedOn:indexAt:)]) {
        [self.chartDelegate CCSChartBeTouchedOn:point indexAt:self.selectedStickIndex];
    }
}

- (CGFloat) calcValueY:(CGFloat)value inRect:(CGRect) rect{
    return (1 - (value - [self minValue]) / ([self maxValue] - [self minValue])) * [self dataQuadrantPaddingHeight:rect] + [self dataQuadrantPaddingStartY:rect];
}
@end
