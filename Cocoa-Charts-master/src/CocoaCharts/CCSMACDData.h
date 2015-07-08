//
//  CCSMACDData.h
//  CocoaChartsSample
//
//  Created by limc on 11/12/13.
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

#import "CCSBaseData.h"

@interface CCSMACDData : CCSBaseData {
    CGFloat _dea;
    CGFloat _diff;
    CGFloat _macd;
    NSString *_date;
}

@property(assign, nonatomic) CGFloat dea;
@property(assign, nonatomic) CGFloat diff;
@property(assign, nonatomic) CGFloat macd;
@property(retain, nonatomic) NSString *date;

- (id)initWithDea:(CGFloat)dea diff:(CGFloat)diff macd:(CGFloat)macd date:(NSString *)date;

@end
