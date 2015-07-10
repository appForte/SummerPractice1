//
//  MyTableViewCell.m
//  SimpleTable
//
//  Created by Tekla on 02/07/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import "MyTableViewCell.h"
#import "FavouriteButtonState.h"
@implementation MyTableViewCell
{
    UIButton* _button;
    
}
@synthesize _favourite;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithFood:(STFood *)food andState:(BOOL)state andRowIndex:(int)rowIndex andAdjust:(SimpleTableViewController*)adjust
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    
    /*CGFloat cellWidth = self.frame.size.width;
    CGFloat cellHeight = self.frame.size.height; */
    
    NSLog(@"WIDTH CELL:%lf",adjust.view.frame.size.width);
    
    button.frame = CGRectMake(adjust.view.frame.size.width-100,10,100,30);
    
    self._favourite=state;
    
    
    [self addSubview:button];
    [button addTarget:self action:@selector(favouriteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];    
    _button=button;
    [self updateWithFood:food andState:state andRowIndex:rowIndex ];
}

-(void) updateWithFood:(STFood*)food andState:(BOOL)state andRowIndex:(int)rowIndex
{
    self.imageView.image = [UIImage imageNamed:food.imageName];
    self.textLabel.text=food.name;
    self._favourite=state;
    _button.tag=food.ind;
    //_rowIndex=rowIndex;
    _rowIndex=food.ind;
    _swipped=NO;
    if(self._favourite == NO)
    {
        [_button setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_button setImage:[UIImage imageNamed:@"heart_selected.png"] forState:UIControlStateNormal];
    }
    
    UISwipeGestureRecognizer *swipeGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGest.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    [self addGestureRecognizer:swipeGest];
    
}
-(IBAction)handleSwipeGesture:(id)sender
{
    _swipped=YES;
    [self.delegate didSwipeWithIndex:_rowIndex];
    NSLog(@"Left gesture on row:%i\n",_rowIndex);
}

-(IBAction)favouriteButtonTouched:(UIButton*)sender
{
    NSLog(@"Button touched at id:%i.\n",sender.tag);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * key =@"favouriteFoods";
    self._favourite=!self._favourite;
    if(self._favourite== NO)
    {
        [sender setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        
        /*NSNumber *state = [NSNumber numberWithInteger:0];
        
        NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",sender.tag];
        [defaults setObject:state forKey:selectedRow]; */
        
        
        
        NSString * key = @"favouriteFoods";
        NSMutableArray * favouriteFoods =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
        NSNumber * requestedFood = [NSNumber numberWithInteger:sender.tag];
        if ([favouriteFoods containsObject: requestedFood])
        {
            NSLog(@"Food found in defaults.\n");
            [favouriteFoods removeObjectIdenticalTo:requestedFood];
            [defaults setObject:favouriteFoods forKey:key];            
            
        }
        [defaults synchronize];
    }
    else
    {   //defaults beallitasa
        [sender setImage:[UIImage imageNamed:@"heart_selected.png"] forState:UIControlStateNormal];
        
        /*NSNumber *state = [NSNumber numberWithInteger:1];
        
        NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",sender.tag];
        [defaults setObject:state forKey:selectedRow]; */
        
        
        NSMutableArray * favouriteFoods = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
        NSNumber *foodId = [NSNumber numberWithInteger:sender.tag];
        [favouriteFoods addObject:foodId];
        [defaults setObject:favouriteFoods forKey:key];
        [defaults synchronize];
        
    }
    //[defaults synchronize];
}
-(BOOL)isFavourited
{
    return self._favourite;
    
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
