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
#import "FoodDatabase.h"
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.1;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 264;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT =352;
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
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *but= [UIButton buttonWithType:UIButtonTypeCustom];
    [ but addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(self.view.frame.origin.x, 12, 145, 40)];
    [ but setTitle:@"Back" forState:UIControlStateNormal];
    
    but.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    but.titleLabel.textColor = [UIColor blueColor];
    
    
    
    
    [ but setExclusiveTouch:YES];
    
    
    
    
    
    [self.view addSubview:but];
    
    
    
    
    [_saveBut addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //_saveBut.buttonType=UIButtonTypeCustom;
    
   _saveBut.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
   _saveBut.titleLabel.textColor=[UIColor blueColor];
    
    _saveBut.enabled=NO;
   
    
    [_saveBut setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_saveBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [self.view addSubview:_saveBut];
    
    _fieldName.backgroundColor=[UIColor clearColor];
    _fieldDescription.backgroundColor=[UIColor clearColor];
    _fieldImg.backgroundColor=[UIColor clearColor];
    
    [_fieldName setBorderStyle:UITextBorderStyleLine];
    [_fieldDescription setBorderStyle:UITextBorderStyleLine];
    [_fieldImg setBorderStyle:UITextBorderStyleLine];
    
}


/*- (void)willAnimateRotationToInterfaceOrientation:
 (UIInterfaceOrientation)toInterfaceOrientation
 duration:(NSTimeInterval)duration
 {
 if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
 toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
 {
 _labelMain.frame = CGRectMake(_labelName.frame.origin.x,_labelName.frame.origin.y,self.view.frame.size.width,_labelName.frame.size.height);
 
 
 
 
 }
 else
 {
 _labelName.frame = CGRectMake(_labelName.frame.origin.x,_labelName.frame.origin.y,self.view.frame.size.width,_labelName.frame.size.height);
 
 }
 }*/


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
    
    CGRect frame =_labelMain.frame;
    frame.origin.x=self.view.frame.origin.x;
    frame.origin.y=self.view.frame.origin.y;
    frame.size.height=_labelMain.frame.size.height;
    frame.size.width=self.view.frame.size.width;
    _labelMain.frame=frame;
    
    
    
    
    NSLog(@"Insert view width:%lf",self.view.frame.size.width);
    
    
    
    
    
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
    
    
}
- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveButtonClicked:(id)sender
{
    STFood * food = [ [STFood alloc] init ];
    food.name=_fieldName.text;
    food.imageName=_fieldImg.text;
    
    
    FoodDatabase *db = [FoodDatabase initDatabase];
    NSArray *foods = [db foodInfos];
    food.ind=[foods count];
    NSLog(@"Number of foods:%i",[foods count]);
    
    [db insertFood:food ];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    /*CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];*/
    
    
    CGFloat midline = textField.frame.origin.y + 0.5*textField.frame.size.height;
    CGFloat numerator = midline - self.view.window.frame.origin.y - MINIMUM_SCROLL_FRACTION * self.view.window.frame.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * self.view.window.frame.size.height;
    
    
    
    CGFloat heightFraction = numerator / denominator;
    
    
    
    NSLog(@"Height fraction:%lf",heightFraction);
    
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
        
        
        
        
        
        NSLog(@"PORTRAIT KEYBOARD :%lf",animatedDistance);
    }
    else
    {
        animatedDistance =LANDSCAPE_KEYBOARD_HEIGHT* heightFraction;
        
        
        NSLog(@"LANDSCAPE KEYBOARD :%lf",animatedDistance);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    //[self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{  CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    
    //[self animateTextField:textField up:NO];
    
    if(_fieldName.text.length > 0 && _fieldImg.text.length > 0 && _fieldDescription.text.length > 0 )
    {
        _saveBut.enabled=YES;
       
    }
    else
    {
        _saveBut.enabled=NO;
    
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




// Call this method somewhere in your view controller setup code.


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
