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
@interface SimpleTableViewController ()

@end

@implementation SimpleTableViewController
{
    NSArray *temp;
    NSMutableArray *tableData;
    FoodData * foodData;
}
- (void)viewDidLoad
{
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [super viewDidLoad];
    // Initialize table data
    foodData = [FoodData initialize];
    tableData = [[NSMutableArray alloc] init];
    /*temp = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
     int tempNumOfElements=[temp count];
     for(int i=0;i<tempNumOfElements;i++)
     {   STFood * food =[[STFood alloc] init];
     food.name=[temp objectAtIndex:i];
     food.imageName=@"creme_brelee.jpg";
     food.ind=i;
     [tableData addObject:(id)food];
     [foodData addFood:food];
     
     }*/
    NSLog(@"View controller called.\n");
    
    STFood* food2 = [foodData getFoodByName:@"Egg Benedict"];
    NSLog(@"Food name is:%@",food2.name);
    STFood * food3 = [ [STFood alloc] init ];
    food3.name=@"Full Breakfast";
    food3.imageName=@"creme_brelee.jpg";
    food3.ind=2;
    
    
    //foodData addFood:food3];
    //NSLog(@"Food name is:%@" ,([foodData getFoodByName:@"Full Breakfast"] ).name );
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [tableData count];
    NSLog(@"Number of foods in tableView:%i",[foodData getNumOfFoods]);
    return [foodData getNumOfFoods];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    STFood * food=[foodData.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text =food.name;
    cell.imageView.image = [UIImage imageNamed:food.imageName];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = tableView.frame;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 30)];
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor whiteColor];
    [addButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 50.0)];
    sectionHeaderView.backgroundColor = [UIColor cyanColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, sectionHeaderView.frame.size.width, 25.0)];
    headerLabel.text = @"Food Menu";
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerLabel setFont:[UIFont fontWithName:@"Verdana" size:20.0]];
    [sectionHeaderView addSubview:headerLabel];
    [sectionHeaderView addSubview:addButton];
    
    return sectionHeaderView;
}
- (IBAction)btnClicked:(id)sender
{   NSLog(@"Under construction.\n");
    InsertViewController * insertView = [[InsertViewController alloc] init];
    [self.navigationController pushViewController:insertView animated:YES ];
}
-(void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    SecondViewController *second = [[SecondViewController alloc] initSecondView: [foodData.dataArray  objectAtIndex:indexPath.row] ]; //initWithNibName:@"SecondViewController" bundle:nil];
    
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
