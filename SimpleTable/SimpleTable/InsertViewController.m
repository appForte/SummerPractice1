//
//  InsertViewController.m
//  SimpleTable
//
//  Created by Tekla on 30/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "InsertViewController.h"
#import "SimpleTableViewController.h"
#import "FoodData.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
@interface InsertViewController ()
{   CGFloat animatedDistance;
}
@end

@implementation InsertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _saveBut.enabled = NO;
    /*[_fieldName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_fieldImg  addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_fieldDescription addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged]; */
    
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ but addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(-30, 12, 145, 40)];
    [ but setTitle:@"Back" forState:UIControlStateNormal];
    [ but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    
    [self.view addSubview:but];
    [_saveBut addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //And so on for all your text fields//button is disable by default
}
- (IBAction)backButtonClicked:(id)sender
{
    //Write a code you want to execute on buttons click event
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveButtonClicked:(id)sender
{
    //Write a code you want to execute on buttons click event
    STFood * food = [ [STFood alloc] init ];
    food.name=_fieldName.text;
    food.imageName=_fieldImg.text;
    FoodData* foodData=[ FoodData initialize];
    food.ind=[foodData getNumOfFoods];
    NSLog(@"Number of foods:%i",[foodData getNumOfFoods]);
    [foodData addFood:food];
    SimpleTableViewController * viewController = [[SimpleTableViewController alloc] init ];
    [self.navigationController pushViewController:viewController animated:YES ];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{   CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    
    
    if(_fieldName.text.length > 0 && _fieldImg.text.length > 0 && _fieldDescription.text.length > 0 )
    {
    
        _saveBut.enabled = YES;
    
    }
    else
    {
    
        _saveBut.enabled = NO;
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{   [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
