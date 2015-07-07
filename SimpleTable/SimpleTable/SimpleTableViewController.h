//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@end

typedef enum {
    YEAR=1,
    MONTH=2,
    DAY=3

} DATE_OPTION;