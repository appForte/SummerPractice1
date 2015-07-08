//
//  CCSStackedAreaChart.m
//  CocoaChartsSample
//
//  Created by limc on 11/14/13.
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

#import "CCSStackedAreaChart.h"
#import "CCSTitledLine.h"
#import "CCSLineData.h"

@implementation CCSStackedAreaChart
@synthesize areaAlpha = _areaAlpha;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initProperty {
    //初始化父类的熟悉
    [super initProperty];
    //去除轴对称属性
    self.areaAlpha = 0.2;
    self.lineAlignType = CCSLineAlignTypeJustify;
}

- (void)calcValueRange {
    if (self.linesData != NULL && [self.linesData count] > 0) {
        double maxValue = 0;
        double minValue = NSIntegerMax;
        
        for (NSUInteger i = 0; i < [self.linesData count]; i++) {
            CCSTitledLine *line = [self.linesData objectAtIndex:i];
            if (line != NULL && [line.data count] > 0) {
                //判断显示为方柱或显示为线条
                for (NSUInteger j = 0; j < [line.data count]; j++) {
                    
                    CCSLineData *lineData = [line.data objectAtIndex:j];
                    CGFloat sumValue = lineData.value;
                    for (NSUInteger k = 0; k < i; k++) {
                        CCSTitledLine *preLine = [self.linesData objectAtIndex:k];
                        if (preLine != NULL) {
                            CCSLineData *lineDataForSum = [preLine.data objectAtIndex:j];
                            sumValue = sumValue + lineDataForSum.value;
                        }
                    }
                    
                    if (sumValue < minValue) {
                        minValue = sumValue;
                    }
                    
                    if (sumValue > maxValue) {
                        maxValue = sumValue;
                    }
                    
                }
            }
        }
        
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
        
    } else {
        self.maxValue = 0;
        self.minValue = 0;
    }
    
    int rate;
    
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
}

- (void)drawData:(CGRect)rect {
    if (self.linesData == nil) {
        return;
    }
    
    if ([self.linesData count] == 0) {
        return;
    }
    // 起始位置
    CGFloat startX;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetAllowsAntialiasing(context, YES);
    
    //逐条输出MA线
    for (NSInteger i = [self.linesData count] - 1; i >= 0; i--) {
        CCSTitledLine *line = [self.linesData objectAtIndex:i];
        
        if (line== nil) {
            continue;
        }
        if ([line.data count] == 0) {
            continue;
        }
        //设置线条颜色
        CGContextSetStrokeColorWithColor(context, line.color.CGColor);
        //获取线条数据
        NSArray *lineDatas = line.data;
        //判断Y轴的位置设置从左往右还是从右往左绘制
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            //TODO:自左向右绘图未对应
            // 点线距离
            CGFloat lineLength = ([self dataQuadrantPaddingWidth:rect] / ([line.data count] - 1));
            //起始点
            startX = [self dataQuadrantPaddingStartX:rect];
            //遍历并绘制线条
            for (NSUInteger j = 0; j < [lineDatas count]; j++) {
                CCSLineData *lineData = [lineDatas objectAtIndex:j];
                //计算Stack的数据和
                CGFloat sumValue = lineData.value;
                for (NSUInteger k = 0; k < i; k++) {
                    CCSTitledLine *preLine = [self.linesData objectAtIndex:k];
                    if (preLine != NULL) {
                        CCSLineData *lineDataForSum = [preLine.data objectAtIndex:j];
                        sumValue = sumValue + lineDataForSum.value;
                    }
                }
                //获取终点Y坐标
                CGFloat valueY = [self calcValueY:sumValue inRect:rect];
                //绘制线条路径
                if (j == 0) {
                    CGContextMoveToPoint(context, startX, valueY);
                } else {
                    CGContextAddLineToPoint(context, startX, valueY);
                }
                //X位移
                startX = startX + lineLength;
            }
        } else {
            
            // 点线距离
            CGFloat lineLength = ([self dataQuadrantPaddingWidth:rect] / ([line.data count] - 1));
            //起始点
            startX = [self dataQuadrantPaddingEndX:rect];
            
            //判断点的多少
            if ([lineDatas count] == 0) {
                //0根则返回
                return;
            } else if ([lineDatas count] == 1) {
                //1根则绘制一条直线
                CCSLineData *lineData = [lineDatas objectAtIndex:0];
                //获取终点Y坐标
                CGFloat valueY = [self calcValueY:lineData.value inRect:rect];
                
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
                    } else if (j == 0) {
                        CGContextAddLineToPoint(context, [self dataQuadrantPaddingStartX:rect], valueY);
                    } else {
                        CGContextAddLineToPoint(context, startX, valueY);
                    }
                    //X位移
                    startX = startX - lineLength;
                }
            }
        }
        
        //备份路径
        CGPathRef path = CGContextCopyPath(context);
        
        //绘制路径
        CGContextStrokePath(context);
        
        CGContextAddPath(context, path);
        if (self.axisYPosition == CCSGridChartYAxisPositionLeft) {
            CGContextAddLineToPoint(context, [self dataQuadrantPaddingEndX:rect], [self dataQuadrantPaddingEndY:rect]);
            CGContextAddLineToPoint(context, [self dataQuadrantPaddingStartX:rect], [self dataQuadrantPaddingEndY:rect]);
        }else{
            CGContextAddLineToPoint(context, [self dataQuadrantPaddingStartX:rect], [self dataQuadrantPaddingEndY:rect]);
            CGContextAddLineToPoint(context, [self dataQuadrantPaddingEndX:rect], [self dataQuadrantPaddingEndY:rect]);
            
        }
        
        CGContextClosePath(context);
        CGContextSetAlpha(context, self.areaAlpha);
        CGContextSetFillColorWithColor(context, line.color.CGColor);
        CGContextFillPath(context);
        
        CGPathRelease(path);
        
        path = nil;
    }
}

@end
