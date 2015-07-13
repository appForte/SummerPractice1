//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SecondViewController.h"
#import "InsertViewController.h"
#import "STFood.h"
#import "FoodData.h"
#import "FoodDatabase.h"
#import "MyTableViewCell.h"
#import "FavouriteButtonState.h"
#import "Quote.h"
#import "FinanceDatabase.h"
#import "CocoaCharts/CCSCandleStickChartViewController.h"
#import "CocoaCharts/CCSCandleStickChartData.h"
@interface SimpleTableViewController () <MyTableViewCellDelegate>
{
     NSMutableArray * candlestickData;
    UIActivityIndicatorView *activityIndicator;
    int frameSizeWidth;
    CGFloat adjust;
    
    CCSCandleStickViewController *_candleStick;
}
@end

@implementation SimpleTableViewController
{
    NSArray *temp;
    NSMutableArray *tableData;
    FoodData * foodData;
    UITableView * _tableView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    foodData = [FoodData initialize];
    activityIndicator=[[UIActivityIndicatorView alloc]
    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [activityIndicator setHidesWhenStopped:YES];
    activityIndicator.center=self.view.center;
    
    NSLog(@"View controller called.\n");
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                  forKey:@"orientation"];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];    
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation] ];
    
}

-(NSArray*)tokenizeByRows:(NSString *) dataStr
{
    NSArray *rows = [dataStr componentsSeparatedByString: @"\n"];
    return rows;
}




-(NSMutableArray*)makeQuotesFromData:(NSString*)dataStr withName:(NSString*)name
{
    NSArray* dataRows =[self tokenizeByRows:dataStr];
    NSMutableArray * quotes = [ [NSMutableArray alloc] init ];
    int numberOfRows = [dataRows count];
    
    if(numberOfRows>0)
    {
        for(int i=1 ; i< numberOfRows-1; i++)
        {
            NSArray * rowContent = [[dataRows objectAtIndex:i] componentsSeparatedByString:@","];
            Quote * quote = [[Quote alloc] init];
            quote.name=name;
            quote.date=[MyDate makeDateFromString:[rowContent objectAtIndex:0]];
            quote.open=[[rowContent objectAtIndex:1] doubleValue];
            quote.high=[[rowContent objectAtIndex:2] doubleValue];
            quote.low=[[rowContent objectAtIndex:3] doubleValue];
            quote.close=[[rowContent objectAtIndex:4] doubleValue];
            quote.volume=[[rowContent objectAtIndex:5] doubleValue];
            quote.adjClose=[[rowContent objectAtIndex:6] doubleValue];
            
            [quotes addObject:(id)quote];
            
            
        }
    }
    return quotes;
    
}

- (void)doDownload:(NSString*)what
{
    
    
    
    
    FinanceDatabase *finDb = [FinanceDatabase initDatabase];
    MyDate * date = [finDb getDateOnlyFor:what];
    MyDate * dateActual = [[MyDate alloc] init];
    dateActual.year= [[MyDate getDate:YEAR] intValue];
    dateActual.month=[[MyDate getDate:MONTH] intValue];
    dateActual.day=[[MyDate getDate:DAY] intValue];
    
    NSString *start =[NSString stringWithFormat:@"%i-%i-%i",date.year,date.month,date.day];
    NSString *end = [NSString stringWithFormat:@"%i-%i-%i",dateActual.year,dateActual.month,dateActual.day];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:start];
    NSDate *endDate = [f dateFromString:end];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSLog(@"%i",components.day);
    
    
    if(components.day>1)
    {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        [self.view addSubview:activityIndicator ];
        [activityIndicator startAnimating];
        
          dispatch_async(queue, ^{
        
        
        
            
              
              NSString * strURL = [NSString stringWithFormat:@"http://ichart.yahoo.com/table.csv?s=%@&a=%i&b=%i&c=%i&d=%i&e=%i&f=%i&g='d'&ignore=.csv",what,date.month-1,date.day,date.year,[[MyDate getDate:MONTH] intValue]-1,[[MyDate getDate:DAY] intValue],[[MyDate getDate:YEAR] intValue] ];
        
              
        
           NSURL *url = [[NSURL alloc] initWithString:strURL];
           NSData *data = [NSData dataWithContentsOfURL:url];
           NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              
              
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  
                  NSLog(@"Downloading data from: %@\n",strURL);
              
            
            
             NSMutableArray* quotes =[self makeQuotesFromData:dataStr withName: what];
            
             for(Quote* quote in quotes)
             {
                
                 
                 if([finDb rowCountFor:what onDate:quote.date]==0)
                 {
                     NSLog(@"Insert");
                     [finDb insertFinData:quote];
                 }
                
                
                
             }
               
           
             NSLog(@"DATE FROM DB WITH GET DATE FUNCTION: %i-%i-%i",date.year,date.month,date.day);
               
               
               NSMutableArray * queryResult = [finDb financialInfosFor:what];
               NSLog(@"DB query result:\n\n\n");
               for(Quote* quote in queryResult)
               {
                   NSLog(@"%@ %i-%i-%i %lf %lf %lf %lf %lf %lf",quote.name, quote.date.year,quote.date.month,quote.date.day,quote.open,quote.high,quote.low,quote.close,quote.volume,quote.adjClose);
                   
                   NSString* formattedDate = [NSString stringWithFormat:@"%i/%i/%i",quote.date.year,quote.date.month,quote.date.day];
                   [candlestickData addObject:[[CCSCandleStickChartData alloc] initWithOpen:quote.open high:quote.high low:quote.low close:quote.close date:formattedDate]];
               }
               
               CCSCandleStickViewController *candleStick =[[CCSCandleStickViewController alloc] init];
               [candleStick initWithData:candlestickData];
                  
                  
                  [activityIndicator stopAnimating];
                  
                  _candleStick=candleStick;
                  
                  [self.navigationController pushViewController:candleStick animated:YES ];
            });
        
        });
    }
    else
    {
        
        NSMutableArray * queryResult = [finDb financialInfosFor:what];
        
        NSLog(@"NO DOWNLOADED DATA : DB query result:\n\n\n");
        for(Quote* quote in queryResult)
        {
            NSLog(@"%@ %i-%i-%i %lf %lf %lf %lf %lf %lf",quote.name, quote.date.year,quote.date.month,quote.date.day,quote.open,quote.high,quote.low,quote.close,quote.volume,quote.adjClose);
            
            NSString* formattedDate = [NSString stringWithFormat:@"%i/%i/%i",quote.date.year,quote.date.month,quote.date.day];
            [candlestickData addObject:[[CCSCandleStickChartData alloc] initWithOpen:quote.open high:quote.high low:quote.low close:quote.close date:formattedDate]];
        }
        
        CCSCandleStickViewController *candleStick =[[CCSCandleStickViewController alloc] init];
        [candleStick initWithData:candlestickData];
        
        
         _candleStick=candleStick;
        
        [self.navigationController pushViewController:candleStick animated:YES ];
        
        
        //[finDb deleteFindatasFor:what];
        
    }
}
-(void)sortTableData
{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [tableData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        STFood * food1 = (STFood *) obj1;
        STFood * food2 = (STFood *) obj2;
        
        NSString * key = @"favouriteFoods";
        NSMutableArray * favouriteFoods = [defaults objectForKey:key];
        NSNumber * requestedFood = [NSNumber numberWithInteger:food1.ind];
        int state1 = 0 , state2 = 0 ;
        if ([favouriteFoods containsObject: requestedFood])
        {
            state1 = 1;
            
        }
        requestedFood = [NSNumber numberWithInteger:food2.ind];
        if ([favouriteFoods containsObject: requestedFood])
        {
            state2 = 1;
        }
        return state1 > state2;
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    NSLog(@"View will apear called.\n");
    
    candlestickData = [[NSMutableArray alloc] init];
    [self refreshButtonTouched:nil ];
    [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation] ];
    
}

-(void) adjustViewsForOrientation:(UIDeviceOrientation) orientation
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGFloat screenWidth = screenRect.size.width;
    
    CGFloat screenHeight = screenRect.size.height;
    
    NSLog(@"ScreenResolution:%lfX%lf",screenWidth,screenHeight);
    
    if(UIDeviceOrientationIsPortrait(orientation))
    {
        NSLog(@"Portrait view detected.\n");
    }
    else
    {
        NSLog(@"Landscape view detected.\n");
    }
    
    switch (orientation)
    {
        
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        {
            NSLog(@"Portrait view detected.\n");
            frameSizeWidth=0;
            adjust=screenWidth;
            NSLog(@"%f",adjust);
            
            
        }
            
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        {
            NSLog(@"Landscape view detected.\n");
            frameSizeWidth=160;
            adjust=screenHeight;
             NSLog(@"%f",adjust);
        }
            break;
        case UIDeviceOrientationUnknown:
            break;
    }
    [_tableView reloadData];
    [_candleStick viewWillAppear:YES];
}
- (void)orientationChanged:(NSNotification *)notification
{
    [self adjustViewsForOrientation:[[UIDevice currentDevice] orientation]];
}

#pragma mark - MyTableViewCellDelegate
-(void)didSwipeWithIndex:(int)_rowIndex
{
    
    NSLog(@"ROWINDEX IS:%i\n",_rowIndex);
    
    FoodDatabase *db = [FoodDatabase initDatabase];
    NSString *deleteWhat = [db getFoodNameForId:_rowIndex];
    [db deleteFood:_rowIndex];
    
    FinanceDatabase *finDb = [FinanceDatabase initDatabase];
    [finDb deleteFindatasFor:deleteWhat];
    
    
    [self refreshButtonTouched:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   //_tableView=tableView;
    
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // _tableView=tableView;
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    STFood * food = [tableData objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * key = @"favouriteFoods";
    NSMutableArray * favouriteFoods = [defaults objectForKey:key];
    NSNumber * requestedFood = [NSNumber numberWithInteger:food.ind];
    BOOL state;
    if ([favouriteFoods containsObject: requestedFood])
    {
        state = YES;
        NSLog(@"Favourited\n");
    }
    else
    {
        state = NO;
        NSLog(@"NOT Favourited\n");
    }
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    if (cell == nil)
    {
        
        
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
        
        
        [cell initWithFood:food andState:state andRowIndex:indexPath.row andAdjust:self];
    }
    else
    {
        [cell updateWithFood:food andState:state andRowIndex:indexPath.row andAdjust:self];
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    _tableView=tableView;
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //_tableView=tableView;
    CGRect frame = tableView.frame;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    
    NSLog(@"Frame size width:%f",(frame.size.width-frameSizeWidth));
    
    NSLog(@"Adjust %f",adjust);
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(adjust-60.0, 10, 50, 30)];
    
    
    
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    [addButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSLog(@"WIDTH::::::%lf",frame.size.width);  //320 ------ 480
    
    //(frame.size.width-frameSizeWidth)-300
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x+10, 10, 80, 30)];
    [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
    [refresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     refresh.backgroundColor = [UIColor whiteColor];
    [refresh addTarget:self action:@selector(refreshButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    sectionHeaderView.backgroundColor = [UIColor cyanColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, (adjust-frameSizeWidth)+frameSizeWidth, 25.0)];
    
    
    //sectionHeaderView.frame.size.width
    
    
    headerLabel.text = @"Food Menu";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:20.0]];
    [sectionHeaderView addSubview:headerLabel];
    [sectionHeaderView addSubview:addButton];
    [sectionHeaderView addSubview:refresh];
    
    return sectionHeaderView;
}
- (IBAction)refreshButtonTouched:(id)sender
{
    
    FoodDatabase *db = [FoodDatabase initDatabase];
    tableData = [db foodInfos ];
    [self sortTableData];
    
    [_tableView reloadData];
    
    
}
- (IBAction)btnClicked:(id)sender
{
    InsertViewController * insertView = [[InsertViewController alloc] init];
    [self.navigationController pushViewController:insertView animated:YES ];
}

-(void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    //SecondViewController *second = [[SecondViewController alloc] initSecondView: [tableData  objectAtIndex:indexPath.row] ];
    
    STFood * food = [tableData objectAtIndex:indexPath.row];
    [self doDownload:food.name];
    
    
    //UITextView *textViewLocal = [[UITextView alloc] initWithFrame:CGRectMake(0,0,140,140)];
    //second.textView=textViewLocal;
    //[second.textView setText:@"abc"];
    
    
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self adjustViewsForOrientation:[[UIDevice currentDevice] orientation] ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
