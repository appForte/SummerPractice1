//
//  MyTableViewCell.h
//  SimpleTable
//
//  Created by Tekla on 02/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFood.h"
#import "SimpleTableViewController.h"

@protocol MyTableViewCellDelegate <NSObject>
@required
- (void)didSwipeWithIndex:(int)_rowIndex;
@end

@interface MyTableViewCell : UITableViewCell
{
    /*NSString *_imageName;
    NSString *_cellContent; */
    BOOL _favourite;
    BOOL _swipped;
    int _rowIndex;
    
}

/*@property (nonatomic,strong,setter = imageName:, getter = imageName) NSString *_imageName;
@property (nonatomic,strong,setter = cellContent:, getter = cellContent) NSString *_cellContent; */
@property (nonatomic,assign,setter = favourite:, getter = favourite ) BOOL _favourite;
@property (nonatomic, weak) id<MyTableViewCellDelegate> delegate;
-(void)initWithFood:(STFood *)food andState:(BOOL)state andRowIndex:(int)rowIndex andAdjust:(SimpleTableViewController*)adjust;
-(IBAction)favouriteButtonTouched:(id)sender;
-(IBAction)handleSwipeGesture:(id)sender;
-(BOOL)isFavourited;
-(void) updateWithFood:(STFood*)food andState:(BOOL)state andRowIndex:(int)rowIndex andAdjust:(SimpleTableViewController*)adjust;
@end

