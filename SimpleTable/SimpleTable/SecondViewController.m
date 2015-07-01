//
//  SecondViewController.m
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "SecondViewController.h"
#import "SimpleTableViewController.h"
@interface SecondViewController ()
{   NSString * info;
    STFood * foodInfo;
    
}

@end

@implementation SecondViewController

//@synthesize textView;
-(id)initSecondView:(STFood*)food
{   info=[[NSString alloc] initWithFormat:@"\n\nFood name: %@\n\n Image name:%@\n\n",food.name,food.imageName];
     foodInfo=food;
        return self;
    
}

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
    [ _textView setText:info];
    [ _label setText:[NSString stringWithFormat:@"%i", foodInfo.ind]];
    [_imageView setImage:[UIImage imageNamed:foodInfo.imageName]];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ but addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(52, 12, 215, 40)];
    [ but setTitle:@"Back" forState:UIControlStateNormal];
    [ but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
        
    [self.view addSubview:but];
}
- (IBAction)btnClicked:(id)sender
{
    //Write a code you want to execute on buttons click event
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
