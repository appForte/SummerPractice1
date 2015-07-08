//
//  CCSLineChart.m
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

#import "CCSLineChart.h"
#import "CCSTitledLine.h"
#import "CCSLineData.h"

@implementation CCSLineChart

@synthesize linesData = _linesData;
@synthesize latitudeNum = _latitudeNum;
@synthesize longitudeNum = _longitudeNum;
@synthesize selectedIndex = _selectedIndex;
@synthesize lineWidth = _lineWidth;
@synthesize maxValue = _maxValue;
@synthesize minValue = _minValue;
@synthesize axisCalc = _axisCalc;
@synthesize lineAlignType = _lineAlignType;

- (void)initProperty {

    [super initProperty];

    self.latitudeNum = 3;
    self.longitudeNum = 3;
    self.maxValue = NSIntegerMin;
    self.minValue = NSIntegerMax;
    self.selectedIndex = 0;
    self.lineWidth = 1.0f;
    self.axisCalc = 1;
    self.lineAlignType = CCSLineAlignTypeCenter;

    self.linesData = nil;
}

- (void)dealloc {
    [_linesData release];
    [super dealloc];
}

- (void)calcDataValueRange
{
    double maxValue = 0;
    double minValue = NSIntegerMax;
    //逐条输出MA线
    for (NSUInteger i = 0; i < [self.linesData count]; i++) {
        CCSTitledLine *line = [self.linesData objectAtIndex:i];
        if (line != NULL && [line.data count] > 0) {
            //判断显示为方柱或显示为线条
            for (NSUInteger j = 0; j < [line.data count]; j++) {
                CCSLineData *lineData = [line.data objectAtIndex:j];
                if (lineData.value < minValue) {
                    minValue = lineData.value;
                }
                
                if (lineData.value > maxValue) {
                    maxValue = lineData.value;
                }
                
            }
        }
    }
    
    self.maxValue = maxValue;
    self.minValue = minValue;
}

- (void)calcValueRangePaddingZero
{
    double maxValue = self.maxValue;
    double minValue = self.minValue;
    
    if ((long) maxValue > (long) minValue) {
        if ((maxValue - minValue) < 10. && minValue > 1.) {
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

- (void)calcValueRangeFormatForAxis
{
    int rate = 1;
    
    if (self.maxValue < 3000) {
        rate = 1;
    } else if (self.maxValue >= 3000 && self.maxValue < 5000) {
        rate = 5;
    } else if (self.maxValue >= 5000 && self.maxValue < 30000) {
        rate = 10;
    } else if (self.maxValue >= 30000 && self.maxValue < 50000) {
        rate = 50;
    } else if (self.maxValue >= 50000 && self.maxValue < 300000) {
        rate = 100;
    } else if (self.maxValue >= 300000 && self.maxValue < 500000) {
        rate = 500;
    } else if (self.maxValue >= 500000 && self.maxValue < 3000000) {
        rate = 1000;
    } else if (self.maxValue >= 3000000 && self.maxValue < 5000000) {
        rate = 5000;
    } else if (self.maxValue >= 5000000 && self.maxValue < 30000000) {
        rate = 10000;
    } else if (self.maxValue >= 30000000 && self.maxValue < 50000000) {
        rate = 50000;
    } else {
        rate = 100000;
    }
    
    //等分轴修正
    if (self.latitudeNum > 0 && rate > 1 && (long) (self.minValue) % rate != 0) {
        //最大值加上轴差
        self.minValue = (long) self.minValue - ((long) (self.minValue) % rate);
    }
    //等分轴修正
    if (self.latitudeNum > 0 && (long) (self.maxValue - self.minValue) % (self.latitudeNum * rate) != 0) {
        //最大值加上轴差
        self.maxValue = (long) self.maxValue + (self.latitudeNum * rate) - ((long) (self.maxValue - self.minValue) % (self.latitudeNum * rate));
    }
    
    //    //等分轴修正
    //    if (self.latitudeNum >0 && (int)(self.maxValue - self.minValue) % (self.latitudeNum) != 0) {
    //        //最大值加上轴差
    //        self.maxValue = self.maxValue + self.latitudeNum - ((int)(self.maxValue - self.minValue) % self.latitudeNum);
    //    }
}


- (void)calcValueRange {
    if (self.linesData != NULL && [self.linesData count] > 0) {
        [self calcDataValueRange];
        [self calcValueRangePaddingZero];
    } else {
        self.maxValue = 0;
        self.minValue = 0;
    }
    
    [self calcValueRangeFormatForAxis];
}

- (void)drawRect:(CGRect)rect {

    //初始化XY轴
    [self initAxisX];
    [self initAxisY];

    [super drawRect:rect];

    //绘制数据
    [self drawData:rect];
}

- (void)drawData:(CGRect)rect {

    // 起始位置
    CGFloat startX = 0;
    CGFloat lastY = 0;
    CGFloat lineLength = 0;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAllowsAntialiasing(context, YES);

    //linesData为空
    if (self.linesData == NULL){
        return;
    }

    //逐条输出
    for (NSUInteger i = 0; i < [self.linesData count]; i++) {
        CCSTitledLine *line = [self.linesData objectAtIndex:i];
        //line为空
        if (line == NULL) {
            continue;
        }

        //设置线条颜色
        CGContextSetStrokeColorWithColor(context, line.color.CGColor);
        //获取线条数据
        NSArray *lineDatas = line.data;

        //判断Y轴的位置设置从左往右还是从右往左绘制
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {

            if (self.lineAlignType == CCSLineAlignTypeCenter) {
                // 点线距离
                lineLength= ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
                //起始点
                startX = [self dataQuadrantPaddingStartX:rect] + lineLength / 2;
            }else {
                // 点线距离
                lineLength= ([self dataQuadrantPaddingWidth:rect] / ([line.data count] - 1));
                //起始点
                startX = [self dataQuadrantPaddingStartX:rect];
            }


            //遍历并绘制线条
            for (NSUInteger j = 0; j < [lineDatas count]; j++) {
                CCSLineData *lineData = [lineDatas objectAtIndex:j];
                //获取终点Y坐标
                CGFloat valueY = [self calcValueY:lineData.value inRect:rect];
                //绘制线条路径
                if (j == 0) {
                    CGContextMoveToPoint(context, startX, valueY);
                    lastY = valueY;
                } else {
                    if (lineData.value == 0) {
                        CGContextMoveToPoint(context, startX, lastY);
                    } else {
                        CGContextAddLineToPoint(context, startX, valueY);
                        lastY = valueY;
                    }
                }
                //X位移
                startX = startX + lineLength;
            }
        } else {

            if (self.lineAlignType == CCSLineAlignTypeCenter) {
                // 点线距离
                lineLength = ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
                //起始点
                startX = [self dataQuadrantPaddingEndX:rect] - lineLength / 2;
            }else{
                // 点线距离
                lineLength= ([self dataQuadrantPaddingWidth:rect] / ([line.data count] - 1));
                //起始点
                startX = [self dataQuadrantPaddingEndX:rect];
            }

            //判断点的多少
            if ([lineDatas count] == 0) {
                //0根则返回
                return;
            } else if ([lineDatas count] == 1) {
                //1根则绘制一条直线
                CCSLineData *lineData = [lineDatas objectAtIndex:0];
                //获取终点Y坐标
                CGFloat valueY =  [self calcValueY:lineData.value inRect:rect];

                CGContextMoveToPoint(context, startX, valueY);
                CGContextAddLineToPoint(context, [self dataQuadrantPaddingStartX:rect], valueY);

            } else {
                //遍历并绘制线条
                for (NSInteger j = [lineDatas count] - 1; j >= 0; j--) {
                    CCSLineData *lineData = [lineDatas objectAtIndex:j];
                    //获取终点Y坐标
                    CGFloat valueY = [self calcValueY:lineData.value inRect:rect];
                    //绘制线条路径
                    if (j == [lineDatas count] - 1) {
                        CGContextMoveToPoint(context, startX, valueY);
                        lastY = valueY;
                    } else {
                        if (lineData.value == 0) {
                            CGContextMoveToPoint(context, startX, lastY);
                        } else {
                            CGContextAddLineToPoint(context, startX, valueY);
                            lastY = valueY;
                        }
                    }
                    //X位移
                    startX = startX - lineLength;
                }
            }
        }

        //绘制路径
        CGContextStrokePath(context);
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
    CGFloat lineLength=0;
    
    if (self.linesData != nil && [self.linesData count] >0) {
        CCSTitledLine *line = [self.linesData objectAtIndex:0];
        //line为空
        if (line != nil) {
            lineLength= ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
        }
    }
    if (self.lineAlignType == CCSLineAlignTypeCenter) {
        postOffset= ([self dataQuadrantPaddingWidth:rect] - lineLength) / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect] + lineLength/2;
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
    CGFloat lineLength=0;
    
    if (self.linesData != nil && [self.linesData count] >0) {
        CCSTitledLine *line = [self.linesData objectAtIndex:0];
        //line为空
        if (line != nil) {
            lineLength= ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
        }
    }
    
    if (self.lineAlignType == CCSLineAlignTypeCenter) {
        postOffset= ([self dataQuadrantPaddingWidth:rect] - lineLength) / ([self.longitudeTitles count] - 1);
        offset = [self dataQuadrantPaddingStartX:rect] + lineLength/2;
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


//- (void)drawLongitudeLines:(CGRect)rect {
//    if (self.lineAlignType == CCSLineAlignTypeJustify) {
//        [super drawLongitudeLines:rect];
//        return;
//    }
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 0.5f);
//    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
//    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
//
//    if (self.displayLongitude == NO) {
//        return;
//    }
//
//    if ([self.longitudeTitles count] <= 0) {
//        return;
//    }
//    //设置线条为点线
//    if (self.dashLongitude) {
//        CGFloat lengths[] = {3.0, 3.0};
//        CGContextSetLineDash(context, 0.0, lengths, 2);
//    }
//    CGFloat postOffset;
//    CGFloat offset;
//    CGFloat lineLength = 0;
//    
//    if (self.linesData != nil && [self.linesData count] >0) {
//        CCSTitledLine *line = [self.linesData objectAtIndex:0];
//        //line为空
//        if (line != nil) {
//            lineLength= ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
//        }
//    }
//
//    postOffset = ([self dataQuadrantPaddingWidth:rect]) / ([self.longitudeTitles count]);
//    offset = [self dataQuadrantPaddingStartX:rect] + lineLength / 2;
//
//    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
//        CGContextMoveToPoint(context, offset + i * postOffset, [self dataQuadrantStartY:rect]);
//        CGContextAddLineToPoint(context, offset + i * postOffset, [self dataQuadrantEndY:rect]);
//    }
//
//    CGContextStrokePath(context);
//    CGContextSetLineDash(context, 0, nil, 0);
//}
//
//- (void)drawXAxisTitles:(CGRect)rect {
//    if (self.lineAlignType == CCSLineAlignTypeJustify) {
//        [super drawXAxisTitles:rect];
//        return;
//    }
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 0.5f);
//    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
//    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
//
//    if (self.displayLongitude == NO) {
//        return;
//    }
//
//    if (self.displayLongitudeTitle == NO) {
//        return;
//    }
//
//    if ([self.longitudeTitles count] <= 0) {
//        return;
//    }
//
//    CGFloat postOffset;
//    CGFloat offset;
//    CGFloat lineLength;
//
//    if (self.linesData != nil && [self.linesData count] >0) {
//        CCSTitledLine *line = [self.linesData objectAtIndex:0];
//        //line为空
//        if (line != nil) {
//            lineLength= ([self dataQuadrantPaddingWidth:rect] / [line.data count]);
//        }
//    }
//    
//    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
//        postOffset = ([self dataQuadrantPaddingWidth:rect]) / ([self.longitudeTitles count]);
//        offset = [self dataQuadrantPaddingStartX:rect] + lineLength / 2;
//    } else {
//        postOffset = ([self dataQuadrantPaddingWidth:rect])/ ([self.longitudeTitles count]);
//        offset = [self dataQuadrantPaddingStartX:rect] + lineLength / 2;
//    }
//
//    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
//        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
//            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
//
//            //调整X轴坐标位置
//            [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, [self dataQuadrantEndY:rect] + [self axisWidth], postOffset, self.longitudeFontSize)
//                   withFont:self.longitudeFont
//              lineBreakMode:NSLineBreakByWordWrapping
//                  alignment:NSTextAlignmentCenter];
//        } else {
//            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
//
//            //调整X轴坐标位置
//            [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, 0, postOffset, self.longitudeFontSize)
//                   withFont:self.longitudeFont
//              lineBreakMode:NSLineBreakByWordWrapping
//                  alignment:NSTextAlignmentCenter];
//        }
//    }
//}


- (void)initAxisY {
    //计算值幅范围
    [self calcValueRange];

    if (self.maxValue == 0. && self.minValue == 0.) {
        self.latitudeTitles = nil;
        return;
    }

    NSMutableArray *TitleY = [[[NSMutableArray alloc] init] autorelease];
    CGFloat average = (NSUInteger) ((self.maxValue - self.minValue) / self.latitudeNum);
    //计算title
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
    //最后一个title
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



- (void)initAxisX {
    if(self.linesData == nil){
        return;
    }
    if([self.linesData count] == 0){
        return;
    }
    
    NSMutableArray *TitleX = [[[NSMutableArray alloc] init] autorelease];
    //以第1条线作为X轴的标示
    CCSTitledLine *line = [self.linesData objectAtIndex:0];
    if ([line.data count] > 0) {
        CGFloat average = [line.data count] / self.longitudeNum;
        //处理刻度
        for (NSUInteger i = 0; i < self.longitudeNum; i++) {
            NSUInteger index = (NSUInteger) floor(i * average);
            if (index >= [line.data count] - 1) {
                index = [line.data count] - 1;
            }
            CCSLineData *lineData = [line.data objectAtIndex:index];
            //追加标题
            [TitleX addObject:[NSString stringWithFormat:@"%@", lineData.date]];
        }
        CCSLineData *lineData = [line.data objectAtIndex:[line.data count] - 1];
        //追加标题
        [TitleX addObject:[NSString stringWithFormat:@"%@", lineData.date]];
    }
    self.longitudeTitles = TitleX;
}

- (NSString *)calcAxisXGraduate:(CGRect)rect {
    if(self.linesData == nil){
        return @"";
    }
    if([self.linesData count] == 0){
        return @"";
    }
    
    CGFloat value = [self touchPointAxisXValue:rect];
    NSString *result = @"";
    
    CCSTitledLine *line = [self.linesData objectAtIndex:0];
    if (line == nil){
        return @"";
    }
    if([line.data count] == 0) {
        return @"";
    }
    
    if (value >= 1) {
        result = ((CCSLineData *) [line.data objectAtIndex:[line.data count] - 1]).date;
    } else if (value <= 0) {
        result = ((CCSLineData *) [line.data objectAtIndex:0]).date;
    } else {
        NSUInteger index = (NSUInteger) round([line.data count] * value);
        
        if (index < [line.data count]) {
            self.displayCrossXOnTouch = YES;
            self.displayCrossYOnTouch = YES;
            result = ((CCSLineData *) [line.data objectAtIndex:index]).date;
        } else {
            self.displayCrossXOnTouch = NO;
            self.displayCrossYOnTouch = NO;
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
        NSUInteger degree = (value * (self.maxValue - self.minValue) + self.minValue) / self.axisCalc;
        return [[NSNumber numberWithUnsignedInteger:degree]stringValue];
    } else {
        return [NSString stringWithFormat:@"%-.2f", (value * (self.maxValue - self.minValue) + self.minValue) / self.axisCalc];
    }
}


- (void) setLinesData:(NSArray *)linesData
{
    [_linesData autorelease];
    _linesData = [linesData retain];
    
    self.maxValue = NSIntegerMin;
    self.minValue = NSIntegerMax;
}

- (CGFloat) calcValueY:(CGFloat)value inRect:(CGRect) rect{
    return (1 - (value - [self minValue]) / ([self maxValue] - [self minValue])) * [self dataQuadrantPaddingHeight:rect] + [self dataQuadrantPaddingStartY:rect];
}

@end
