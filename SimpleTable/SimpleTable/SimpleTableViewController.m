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
@interface SimpleTableViewController () <MyTableViewCellDelegate>
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
    
    
    //[self doDownload:@"AAPL"];
    
    NSLog(@"View controller called.\n");
    
   
    
    
}

-(NSString*)getDate:(int)option
{   NSDate *currentDate = [[NSDate alloc] init];
    
    // or specifc Timezone: with name
    NSString *localDateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch(option)
    {
        case 1:
        {
           [dateFormatter setDateFormat:@"yyyy"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
        case 2:
        {
            [dateFormatter setDateFormat:@"MM"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
        default:
        {
            [dateFormatter setDateFormat:@"dd"];
            localDateString = [dateFormatter stringFromDate:currentDate];
            break;
        }
    }
   
    
    return localDateString;
    
}


- (void)doDownload:(NSString*)what
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    
    
    dispatch_async(queue, ^{
        NSString * strURL = [NSString stringWithFormat:@"http://ichart.yahoo.com/table.csv?s=%@&a=3&b=1&c=2015&d=%@&e=%@&f=%@&g='d'&ignore=.csv",what,[self getDate:2],
                             [self getDate:3],[self getDate:1]];
        NSURL *url = [[NSURL alloc] initWithString:strURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Downloading data from: %@\n",strURL);
            NSLog(@"Data:%@\n",dataStr);
        });
    });
}
-(void)sortTableData
{
    //int k=0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [tableData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        STFood * food1 = (STFood *) obj1;
        STFood * food2 = (STFood *) obj2;
        
        /*NSString * selectedRow1 =[ [NSString alloc] initWithFormat:@"%i",food1.ind];
        NSNumber *state1 = [defaults objectForKey:selectedRow1];
        
        NSString * selectedRow2 =[ [NSString alloc] initWithFormat:@"%i",food2.ind];
        NSNumber *state2 = [defaults objectForKey:selectedRow2];*/
        
        
        
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
    
    
 /*
    do
    {
        k=0;
        for(int i=0; i < ([tableData count]-1); i++ )
        {
            STFood * food1 = [tableData objectAtIndex:i];
            STFood * food2 = [tableData objectAtIndex:i+1];
            
            NSString * selectedRow1 =[ [NSString alloc] initWithFormat:@"%i",food1.ind];
            NSNumber *state1 = [defaults objectForKey:selectedRow1];
            
            NSString * selectedRow2 =[ [NSString alloc] initWithFormat:@"%i",food2.ind];
            NSNumber *state2 = [defaults objectForKey:selectedRow2];
            
            if(state1!=nil&&state2!=nil)
            {   NSLog(@"state1:%i state2:%i\n",[state1 intValue],[state2 intValue]);
                if([state1 intValue] > [state2 intValue])
                {
                    NSLog(@"R\n");
                    [tableData replaceObjectAtIndex:i withObject:food2];
                    [tableData replaceObjectAtIndex:i+1 withObject:food1];
                    k=1;
                }
                
            }
            
            
            
        }
    }while(k==1);
    */
    
}

-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    NSLog(@"View will apear called.\n");
    [self refreshButtonTouched:nil ];
    
    
    
    
}
#pragma mark - MyTableViewCellDelegate
-(void)didSwipeWithIndex:(int)_rowIndex
{
    
    NSLog(@"ROWINDEX IS:%i\n",_rowIndex);
    
     FoodDatabase *db = [FoodDatabase initDatabase];
    [db deleteFood:_rowIndex];
    [self refreshButtonTouched:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   //_tableView=tableView;
    //NSLog(@"Number of foods in tableView:%i",[tableData count]);
    return [tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   // _tableView=tableView;
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    STFood * food = [tableData objectAtIndex:indexPath.row];
    
    
    //NSLog(@"Food with id:%i %@",food.ind,food.name);
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",food.ind];
    NSNumber *result = [defaults objectForKey:selectedRow];
    
    BOOL state = NO;
    if(result!=nil)
    {
        if([result intValue]==1)
        {   state=YES;
            NSLog(@"Favourited\n");
            
        }
        else
        {
            NSLog(@"NOT Favourited\n");
            
        }
        
    }*/
    
    
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
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        [cell initWithFood:food andState:state andRowIndex:indexPath.row];
    }
    else
    {
        [cell updateWithFood:food andState:state andRowIndex:indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    _tableView=tableView;
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //_tableView=tableView;
    CGRect frame = tableView.frame;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 30)];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    [addButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-300, 10, 80, 30)];
    [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
    [refresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     refresh.backgroundColor = [UIColor whiteColor];
    [refresh addTarget:self action:@selector(refreshButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    sectionHeaderView.backgroundColor = [UIColor cyanColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, sectionHeaderView.frame.size.width, 25.0)];
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
-(void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    SecondViewController *second = [[SecondViewController alloc] initSecondView: [tableData  objectAtIndex:indexPath.row] ]; //initWithNibName:@"SecondViewController" bundle:nil];
    STFood * food = [tableData objectAtIndex:indexPath.row];
    [self doDownload:food.name];
    [self.navigationController pushViewController:second animated:YES ];
    
    //UITextView *textViewLocal = [[UITextView alloc] initWithFrame:CGRectMake(0,0,140,140)];
    //second.textView=textViewLocal;
    //[second.textView setText:@"abc"];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
