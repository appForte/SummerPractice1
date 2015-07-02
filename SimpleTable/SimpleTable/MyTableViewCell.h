//
//  MyTableViewCell.h
//  SimpleTable
//
//  Created by Tekla on 02/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFood.h"

@interface MyTableViewCell : UITableViewCell
{
    /*NSString *_imageName;
    NSString *_cellContent; */
    BOOL _favourite;
    
    
}

/*@property (nonatomic,strong,setter = imageName:, getter = imageName) NSString *_imageName;
@property (nonatomic,strong,setter = cellContent:, getter = cellContent) NSString *_cellContent; */
@property (nonatomic,assign,setter = favourite:, getter = favourite ) BOOL _favourite;

-(void)initWithFood:(STFood *)food andIndexPathRow:(int)row;
-(IBAction)favouriteButtonTouched:(id)sender;
-(BOOL)isFavourited;
@end

