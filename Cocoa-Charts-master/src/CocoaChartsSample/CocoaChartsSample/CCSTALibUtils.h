//
//  CCSTALibUtils.h
//  CocoaChartsSample
//
//  Created by limc on 2013/12/09.
//  Copyright 2013 limc. All rights reserved.
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

#import <Foundation/Foundation.h>

void NSArrayToCArray(NSArray *array, double outCArray[]);

NSArray *CArrayToNSArray(const double inCArray[], int length, int outBegIdx, int outNBElement);

NSArray *CArrayToNSArrayWithParameter(const double inCArray[], int length, int outBegIdx, int outNBElement, double parmeter);

void freeAndSetNULL(void *ptr);


