//
//  CCSMAStickChartViewController.m
//  Cocoa-Charts
//
//  Created by limc on 13-05-22.
//  Copyright (c) 2012 limc.cn All rights reserved.
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

#import "CCSMAStickChartViewController.h"
#import "CCSStickChartData.h"
#import "CCSMAStickChart.h"
#import "CCSLineData.h"
#import "CCSTitledLine.h"


@interface CCSMAStickChartViewController ()

@end

@implementation CCSMAStickChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.title = @"MA Stick Chart";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    NSMutableArray *stickData = [[[NSMutableArray alloc] init] autorelease];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2010 low:0 date:@"06/30"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2100 low:0 date:@"07/01"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1460 low:0 date:@"07/04"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:920 low:0 date:@"07/05"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1580 low:0 date:@"07/06"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1740 low:0 date:@"07/07"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1690 low:0 date:@"07/08"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:680 low:0 date:@"07/11"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1690 low:0 date:@"07/12"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1950 low:0 date:@"07/13"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:860 low:0 date:@"07/14"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:870 low:0 date:@"07/15"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1310 low:0 date:@"07/19"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1190 low:0 date:@"07/20"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1150 low:0 date:@"07/21"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1580 low:0 date:@"07/22"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2480 low:0 date:@"07/25"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:950 low:0 date:@"07/26"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1780 low:0 date:@"07/27"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1660 low:0 date:@"07/28"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1280 low:0 date:@"07/29"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1340 low:0 date:@"08/01"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1710 low:0 date:@"08/02"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1480 low:0 date:@"08/03"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1210 low:0 date:@"08/04"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4060 low:0 date:@"08/05"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2690 low:0 date:@"08/08"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3980 low:0 date:@"08/09"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1740 low:0 date:@"08/10"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1280 low:0 date:@"08/11"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1250 low:0 date:@"08/12"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:970 low:0 date:@"08/15"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4120 low:0 date:@"08/16"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2330 low:0 date:@"08/17"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2140 low:0 date:@"08/18"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1890 low:0 date:@"08/19"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1320 low:0 date:@"08/22"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1940 low:0 date:@"08/23"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3230 low:0 date:@"08/24"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2760 low:0 date:@"08/25"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1310 low:0 date:@"08/26"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1780 low:0 date:@"08/29"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3760 low:0 date:@"08/30"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3340 low:0 date:@"08/31"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4500 low:0 date:@"09/01"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2780 low:0 date:@"09/02"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2600 low:0 date:@"09/05"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4070 low:0 date:@"09/06"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:8360 low:0 date:@"09/07"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:6540 low:0 date:@"09/08"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:24670 low:0 date:@"09/09"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:14390 low:0 date:@"09/12"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4930 low:0 date:@"09/13"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3950 low:0 date:@"09/14"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:5910 low:0 date:@"09/15"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:17500 low:0 date:@"09/16"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:5300 low:0 date:@"09/20"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2770 low:0 date:@"09/21"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:5300 low:0 date:@"09/22"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2820 low:0 date:@"09/26"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2630 low:0 date:@"09/27"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3780 low:0 date:@"09/28"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2950 low:0 date:@"09/29"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3800 low:0 date:@"09/30"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4220 low:0 date:@"10/03"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4660 low:0 date:@"10/04"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:4490 low:0 date:@"10/05"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3030 low:0 date:@"10/06"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2920 low:0 date:@"10/07"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:7850 low:0 date:@"10/11"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3250 low:0 date:@"10/12"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2290 low:0 date:@"10/13"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2710 low:0 date:@"10/14"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2840 low:0 date:@"10/17"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2410 low:0 date:@"10/18"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2510 low:0 date:@"10/19"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2400 low:0 date:@"10/20"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1580 low:0 date:@"10/21"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2590 low:0 date:@"10/24"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2190 low:0 date:@"10/25"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1520 low:0 date:@"10/26"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2540 low:0 date:@"10/27"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3620 low:0 date:@"10/28"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2880 low:0 date:@"10/31"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2400 low:0 date:@"11/01"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2050 low:0 date:@"11/02"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1400 low:0 date:@"11/04"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1050 low:0 date:@"11/07"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:3700 low:0 date:@"11/08"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1910 low:0 date:@"11/09"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1930 low:0 date:@"11/10"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1430 low:0 date:@"11/11"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:810 low:0 date:@"11/14"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:950 low:0 date:@"11/15"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1310 low:0 date:@"11/16"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1630 low:0 date:@"11/17"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1520 low:0 date:@"11/18"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:980 low:0 date:@"11/21"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:1860 low:0 date:@"11/22"] autorelease]];
    [stickData addObject:[[[CCSStickChartData alloc] initWithHigh:2880 low:0 date:@"11/24"] autorelease]];

    NSMutableArray *linesdata = [[[NSMutableArray alloc] init] autorelease];

    NSMutableArray *linedataMA5 = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1836 date:@"06/30"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1768 date:@"07/01"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1684 date:@"07/04"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1576 date:@"07/05"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1614 date:@"07/06"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1560 date:@"07/07"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1478 date:@"07/08"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1322 date:@"07/11"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1476 date:@"07/12"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1550 date:@"07/13"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1374 date:@"07/14"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1210 date:@"07/15"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1336 date:@"07/19"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1236 date:@"07/20"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1076 date:@"07/21"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1220 date:@"07/22"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1542 date:@"07/25"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1470 date:@"07/26"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1588 date:@"07/27"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1690 date:@"07/28"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1630 date:@"07/29"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1402 date:@"08/01"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1554 date:@"08/02"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1494 date:@"08/03"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1404 date:@"08/04"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1960 date:@"08/05"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2230 date:@"08/08"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2684 date:@"08/09"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2736 date:@"08/10"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2750 date:@"08/11"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2188 date:@"08/12"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1844 date:@"08/15"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1872 date:@"08/16"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1990 date:@"08/17"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2162 date:@"08/18"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2290 date:@"08/19"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2360 date:@"08/22"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1924 date:@"08/23"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2104 date:@"08/24"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2228 date:@"08/25"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2112 date:@"08/26"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2204 date:@"08/29"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2568 date:@"08/30"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2590 date:@"08/31"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2938 date:@"09/01"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3232 date:@"09/02"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3396 date:@"09/05"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3458 date:@"09/06"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4462 date:@"09/07"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4870 date:@"09/08"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:9248 date:@"09/09"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:11606 date:@"09/12"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:11778 date:@"09/13"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:10896 date:@"09/14"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:10770 date:@"09/15"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:9336 date:@"09/16"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:7518 date:@"09/20"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:7086 date:@"09/21"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:7356 date:@"09/22"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:6738 date:@"09/26"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3764 date:@"09/27"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3460 date:@"09/28"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3496 date:@"09/29"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3196 date:@"09/30"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3476 date:@"10/03"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3882 date:@"10/04"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4024 date:@"10/05"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4040 date:@"10/06"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3864 date:@"10/07"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4590 date:@"10/11"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:4308 date:@"10/12"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3868 date:@"10/13"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3804 date:@"10/14"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:3788 date:@"10/17"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2700 date:@"10/18"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2552 date:@"10/19"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2574 date:@"10/20"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2348 date:@"10/21"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2298 date:@"10/24"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2254 date:@"10/25"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2056 date:@"10/26"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2084 date:@"10/27"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2492 date:@"10/28"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2550 date:@"10/31"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2592 date:@"11/01"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2698 date:@"11/02"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2470 date:@"11/04"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1956 date:@"11/07"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2120 date:@"11/08"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2022 date:@"11/09"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1998 date:@"11/10"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:2004 date:@"11/11"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1956 date:@"11/14"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1406 date:@"11/15"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1286 date:@"11/16"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1226 date:@"11/17"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1244 date:@"11/18"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1278 date:@"11/21"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1460 date:@"11/22"] autorelease]];
    [linedataMA5 addObject:[[[CCSLineData alloc] initWithValue:1774 date:@"11/24"] autorelease]];

    CCSTitledLine *lineMA5 = [[[CCSTitledLine alloc] init] autorelease];
    lineMA5.data = linedataMA5;
    lineMA5.color = [UIColor cyanColor];
    lineMA5.title = @"MA5";

    NSMutableArray *linedataMA10 = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];

    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1954 date:@"06/30"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1785 date:@"07/01"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1793 date:@"07/04"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1725 date:@"07/05"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1679 date:@"07/06"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1698 date:@"07/07"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1623 date:@"07/08"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1503 date:@"07/11"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1526 date:@"07/12"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1582 date:@"07/13"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1467 date:@"07/14"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1344 date:@"07/15"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1329 date:@"07/19"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1356 date:@"07/20"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1313 date:@"07/21"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1297 date:@"07/22"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1376 date:@"07/25"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1403 date:@"07/26"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1412 date:@"07/27"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1383 date:@"07/28"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1425 date:@"07/29"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1472 date:@"08/01"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1512 date:@"08/02"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1541 date:@"08/03"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1547 date:@"08/04"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1795 date:@"08/05"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1816 date:@"08/08"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2119 date:@"08/09"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2115 date:@"08/10"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2077 date:@"08/11"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2074 date:@"08/12"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2037 date:@"08/15"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2278 date:@"08/16"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2363 date:@"08/17"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2456 date:@"08/18"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2239 date:@"08/19"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2102 date:@"08/22"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1898 date:@"08/23"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2047 date:@"08/24"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2195 date:@"08/25"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2201 date:@"08/26"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2282 date:@"08/29"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2246 date:@"08/30"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2347 date:@"08/31"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2583 date:@"09/01"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2672 date:@"09/02"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2800 date:@"09/05"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3013 date:@"09/06"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3526 date:@"09/07"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3904 date:@"09/08"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:6240 date:@"09/09"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:7501 date:@"09/12"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:7618 date:@"09/13"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:7679 date:@"09/14"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:7820 date:@"09/15"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:9292 date:@"09/16"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:9562 date:@"09/20"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:9432 date:@"09/21"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:9126 date:@"09/22"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:8754 date:@"09/26"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:6550 date:@"09/27"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:5489 date:@"09/28"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:5291 date:@"09/29"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:5276 date:@"09/30"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:5107 date:@"10/03"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3823 date:@"10/04"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3742 date:@"10/05"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3768 date:@"10/06"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3530 date:@"10/07"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:4033 date:@"10/11"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:4095 date:@"10/12"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3946 date:@"10/13"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3922 date:@"10/14"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3826 date:@"10/17"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3645 date:@"10/18"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3430 date:@"10/19"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3221 date:@"10/20"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3076 date:@"10/21"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:3043 date:@"10/24"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2477 date:@"10/25"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2304 date:@"10/26"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2329 date:@"10/27"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2420 date:@"10/28"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2424 date:@"10/31"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2423 date:@"11/01"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2377 date:@"11/02"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2277 date:@"11/04"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2224 date:@"11/07"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2335 date:@"11/08"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2307 date:@"11/09"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2348 date:@"11/10"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:2237 date:@"11/11"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1956 date:@"11/14"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1763 date:@"11/15"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1654 date:@"11/16"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1612 date:@"11/17"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1624 date:@"11/18"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1617 date:@"11/21"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1433 date:@"11/22"] autorelease]];
    [linedataMA10 addObject:[[[CCSLineData alloc] initWithValue:1530 date:@"11/24"] autorelease]];

    CCSTitledLine *lineMA10 = [[[CCSTitledLine alloc] init] autorelease];
    lineMA10.data = linedataMA10;
    lineMA10.color = [UIColor redColor];
    lineMA10.title = @"MA10";

    [linesdata addObject:lineMA5];
    [linesdata addObject:lineMA10];

    CCSMAStickChart *stickchart = [[[CCSMAStickChart alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, 320, 320)] autorelease];

    stickchart.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    //设置stickData
    stickchart.stickData = stickData;
    stickchart.linesData = linesdata;
    stickchart.maxValue = 26000;
    stickchart.minValue = 0;
    stickchart.displayCrossXOnTouch = YES;
    stickchart.displayCrossYOnTouch = YES;
    stickchart.maxSticksNum = 60;
    stickchart.stickFillColor = [UIColor orangeColor];
    stickchart.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:stickchart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
