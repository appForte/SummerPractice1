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
    self.lineAlignType = CCSLineAlignTypeJustify;

    self.linesData = nil;
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
    [self initAxisY];
    [self initAxisX];

    [super drawRect:rect];

    //绘制数据
    [self drawData:rect];
}

- (void)drawData:(CGRect)rect {

    // 起始位置
    float startX = 0;
    float lastY = 0;
    float lineLength = 0;

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
                lineLength= ((rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / [line.data count]);
                //起始点
                startX = super.axisMarginLeft + lineLength / 2;
            }else if (self.lineAlignType == CCSLineAlignTypeJustify) {
                // 点线距离
                lineLength= ((rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / ([line.data count] - 1));
                //起始点
                startX = super.axisMarginLeft + self.axisMarginRight;
            }
            
            
            //遍历并绘制线条
            for (NSUInteger j = 0; j < [lineDatas count]; j++) {
                CCSLineData *lineData = [lineDatas objectAtIndex:j];
                //获取终点Y坐标
                float valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
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
                float lineLength = ((rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / [line.data count] - 1);
                //起始点
                startX = rect.size.width - self.axisMarginRight - self.axisMarginLeft - lineLength / 2;
            }else if (self.lineAlignType == CCSLineAlignTypeJustify) {
                // 点线距离
                lineLength= ((rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / [line.data count]);
                //起始点
                startX = rect.size.width - self.axisMarginRight - self.axisMarginLeft;
            }

            //判断点的多少
            if ([lineDatas count] == 0) {
                //0根则返回
                return;
            } else if ([lineDatas count] == 1) {
                //1根则绘制一条直线
                CCSLineData *lineData = [lineDatas objectAtIndex:0];
                //获取终点Y坐标
                float valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);

                CGContextMoveToPoint(context, startX, valueY);
                CGContextAddLineToPoint(context, self.axisMarginLeft, valueY);

            } else {
                //遍历并绘制线条
                for (NSInteger j = [lineDatas count] - 1; j >= 0; j--) {
                    CCSLineData *lineData = [lineDatas objectAtIndex:j];
                    //获取终点Y坐标
                    float valueY = ((1 - (lineData.value - self.minValue) / (self.maxValue - self.minValue)) * (rect.size.height - 2 * self.axisMarginTop - self.axisMarginBottom) + self.axisMarginTop);
                    //绘制线条路径
                    if (j == [lineDatas count] - 1) {
                        CGContextMoveToPoint(context, startX, valueY);
                        lastY = valueY;
                    } else if (j == 0) {
                        if (lineData.value == 0) {
//                                    CGContextMoveToPoint(context, startX, lastY);
                            CGContextAddLineToPoint(context, self.axisMarginLeft, lastY);
                        } else {
                            CGContextAddLineToPoint(context, self.axisMarginLeft, valueY);
                            lastY = valueY;
                        }
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
    if (self.lineAlignType == CCSLineAlignTypeJustify) {
        [super drawLongitudeLines:rect];
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context, self.longitudeColor.CGColor);
    CGContextSetFillColorWithColor(context, self.longitudeFontColor.CGColor);
    
    if (self.displayLongitude == NO) {
        return;
    }
    
    if ([self.longitudeTitles count] <= 0) {
        return;
    }
    //设置线条为点线
    if (self.dashLongitude) {
        CGFloat lengths[] = {3.0, 3.0};
        CGContextSetLineDash(context, 0.0, lengths, 2);
    }
    float postOffset;
    float offset;
    
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        postOffset = (rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / ([self.longitudeTitles count]);
        offset = self.axisMarginLeft + self.axisMarginRight + postOffset / 2;
    }
    else {
        //TODO
        postOffset = (rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / ([self.longitudeTitles count]);
        offset = self.axisMarginLeft;
    }
    
    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            CGContextMoveToPoint(context, offset + i * postOffset, 0);
            CGContextAddLineToPoint(context, offset + i * postOffset, rect.size.height - self.axisMarginBottom);
        } else {
            CGContextMoveToPoint(context, offset + i * postOffset, self.axisMarginTop);
            CGContextAddLineToPoint(context, offset + i * postOffset, rect.size.height);
        }
    }
    
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, nil, 0);
}

- (void)drawXAxisTitles:(CGRect)rect {
    if (self.lineAlignType == CCSLineAlignTypeJustify) {
        [super drawXAxisTitles:rect];
        return;
    }
    
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
    
    float postOffset;
    float offset;
    
    if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
        postOffset = (rect.size.width - self.axisMarginLeft - 2 * self.axisMarginRight) / ([self.longitudeTitles count]);
        offset = self.axisMarginLeft + self.axisMarginRight + postOffset / 2;
    } else {
        //TODO
        postOffset = (rect.size.width - 2 * self.axisMarginLeft - self.axisMarginRight) / ([self.longitudeTitles count]);
        offset = self.axisMarginLeft;
    }
    
    for (NSUInteger i = 0; i < [self.longitudeTitles count]; i++) {
        if (self.axisXPosition == CCSGridChartXAxisPositionBottom) {
            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
            
            //调整X轴坐标位置
            [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, rect.size.height - self.axisMarginBottom, postOffset, self.longitudeFontSize)
                   withFont:self.longitudeFont
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
        } else {
            NSString *str = (NSString *) [self.longitudeTitles objectAtIndex:i];
            
            //调整X轴坐标位置
            [str drawInRect:CGRectMake(offset + (i - 0.5) * postOffset, 0, postOffset, self.longitudeFontSize)
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

    NSMutableArray *TitleY = [[NSMutableArray alloc] init];
    float average = (NSUInteger) ((self.maxValue - self.minValue) / self.latitudeNum);
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


- (void)initAxisX {
    NSMutableArray *TitleX = [[NSMutableArray alloc] init];
    if (self.linesData != NULL && [self.linesData count] > 0) {
        //以第1条线作为X轴的标示
        CCSTitledLine *line = [self.linesData objectAtIndex:0];
        if ([line.data count] > 0) {
            float average = [line.data count] / self.longitudeNum;
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
    }
    self.longitudeTitles = TitleX;
}

- (NSString *)calcAxisXGraduate:(CGRect)rect {
    float value = [self touchPointAxisXValue:rect];
    NSString *result = @"";
    if (self.linesData != NULL) {
        CCSTitledLine *line = [self.linesData objectAtIndex:0];
        if (line != NULL && [line.data count] > 0) {
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
        }
    }
    return result;
}

- (NSString *)calcAxisYGraduate:(CGRect)rect {
    float value = [self touchPointAxisYValue:rect];
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
    _linesData = linesData;
    
    self.maxValue = NSIntegerMin;
    self.minValue = NSIntegerMax;
}

//-(void) calcSelectedIndex
//{
//    //X在系统范围内、进行计算
//    if(self.singleTouchPoint.x > self.axisMarginLeft 
//       && self.singleTouchPoint.x < self.frame.size.width)
//    {
//        float stickWidth = ((self.frame.size.width - self.axisMarginLeft -self.axisMarginRight) / self.maxPointsNum);
//        float valueWidth = self.singleTouchPoint.x - self.axisMarginLeft;
//        if(valueWidth > 0)
//        {
//            int index = round(valueWidth / stickWidth);
//            //如果超过则设置位最大
//            if (index >= self.maxPointsNum)
//            {
//                index = self.maxPointsNum - 1;
//            }
//            //设置选中的index
//            self.selectedIndex = index;
//        }
//    }
//}

//-(void) setSelectedPointAddReDraw:(CGPoint)point
//{
//    point.y = 1;
//    self.singleTouchPoint = point;
//    [self calcSelectedIndex];
//    
//    [self setNeedsDisplay];
//}
//
//-(void) setSelectedIndexAddReDraw:(unsigned int)selectedIndex
//{
//    CCSTitledLine *line = [self.linesData objectAtIndex:0];
//    if(selectedIndex < [line.data count])
//    {
//        //计算选中的点
//        float value = ((CCSLineData *)[line.data objectAtIndex:selectedIndex]).value;
//        float ptY = (1 - (value-self.minValue)/(self.maxValue-self.minValue)) * (self.frame.size.height-self.axisMarginBottom-2*self.axisMarginTop) + self.axisMarginTop;
//        
//        float ptX = self.axisMarginLeft + selectedIndex * ((self.frame.size.width - self.axisMarginLeft -2 * self.axisMarginRight) / self.maxPointsNum);
//        
//        self.singleTouchPoint = CGPointMake(ptX,ptY);
//        //设置选中的index
//        self.selectedIndex = selectedIndex;
//    }
//    
//    [self setNeedsDisplay];
//}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //调用父类的触摸事件
//    [super touchesBegan:touches withEvent:event];
//    
//    NSArray *allTouches = [touches allObjects];
//    //处理点击事件
//    if([allTouches count] == 1)
//    {
//        for (CCSLineChart *chart in self.coCharts) {
//            chart.singleTouchPoint = self.singleTouchPoint;        
//            [chart performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
//        }        
//    }
//    
//    float value = [self touchPointAxisXValue:self.frame];
//    if(self.linesData != NULL){
//        CCSTitledLine *line = [self.linesData objectAtIndex:0];
//        int index = 0;
//        if(value >= 1){
//            index = self.maxPointsNum;
//        }else if(value <= 0){
//            index = 0;
//        }else{
//            index = (int)round(self.maxPointsNum * value);
//        }
//        
//        if(index < [line.data count])
//        {
//            float value = ((CCSLineData *)[line.data objectAtIndex:index]).value;
//            float ptY = (1 - (value-self.minValue)/(self.maxValue-self.minValue)) * (self.frame.size.height-self.axisMarginBottom-2*self.axisMarginTop) + self.axisMarginTop;
//            
//            self.singleTouchPoint = CGPointMake(self.singleTouchPoint.x,ptY);
//            
//            [self calcSelectedIndex];
//            
//            float ptX = self.axisMarginLeft + self.selectedIndex * ((self.frame.size.width - self.axisMarginLeft -2 * self.axisMarginRight) / self.maxPointsNum);
//            self.singleTouchPoint = CGPointMake(ptX,ptY);
//
//        }
//    }
//}

//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //调用父类的触摸事件
//    [super touchesMoved:touches withEvent:event];
//     
//    NSArray *allTouches = [touches allObjects];
//    //处理点击事件
//    if([allTouches count] == 1)
//    {
//        for (CCSLineChart *chart in self.coCharts) {
//            chart.singleTouchPoint = self.singleTouchPoint;        
//            [chart performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
//        }  
//    }else if([allTouches count] == 2)
//    {
//        
//    }else{
//        
//    }
//    
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    //调用父类的触摸事件
//    [super touchesEnded:touches withEvent:event];
//    
//    NSArray *allTouches = [touches allObjects];
//    //处理点击事件
//    if([allTouches count] == 1)
//    {
//        for (CCSLineChart *chart in self.coCharts) {
//            chart.singleTouchPoint = self.singleTouchPoint;        
//            [chart performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0];
//        }  
//    }
//}

//-(void) addCoCharts:(CCSLineChart *)chart
//{
//    if(!self.coCharts)
//    {
//        //初始化
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        self.coCharts = arr;
//        [arr release];
//    }
//    
//    //添加chart
//    if(chart)
//    {
//        [self.coCharts addObject:chart];
//    }
//}
@end
