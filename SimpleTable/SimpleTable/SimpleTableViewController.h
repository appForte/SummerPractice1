//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isPortrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown
@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end

