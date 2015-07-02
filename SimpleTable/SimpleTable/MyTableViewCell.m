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
@synthesize _favourite;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithFood:(STFood *)food andIndexPathRow:(int)row
{
    self.imageView.image = [UIImage imageNamed:food.imageName];
    self.textLabel.text=food.name;
    self._favourite = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.imageView.contentMode=UIViewContentModeScaleAspectFit;
    button.frame = CGRectMake(self.frame.origin.x + 220, self.frame.origin.y + 10, 100, 30);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",row];
    NSNumber *state = [defaults objectForKey:selectedRow];
    if(state!=nil)
    {
        if([state intValue]==1)
        {   NSLog(@"Favourited\n");
            self._favourite=YES;
        }
        else
        {
            NSLog(@"NOT Favourited\n");
            
        }
            
    }
    if(self._favourite == NO)
    {
        [button setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"heart_selected.png"] forState:UIControlStateNormal];
    }
    
    
    [button setImage:[UIImage imageNamed:@"heart_selected.png"] forState:UIControlStateSelected];
    button.tag=row;
    [self addSubview:button];
    [button addTarget:self action:@selector(favouriteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];    
    
}
-(IBAction)favouriteButtonTouched:(UIButton*)sender
{
    NSLog(@"Button touched at row:%i.\n",sender.tag);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self._favourite=!self._favourite;
    if(self._favourite== NO)
    {
        [sender setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        
        NSNumber *state = [NSNumber numberWithInteger:0];
        
        NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",sender.tag];
        [defaults setObject:state forKey:selectedRow];
        
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"heart_selected.png"] forState:UIControlStateNormal];
        
        NSNumber *state = [NSNumber numberWithInteger:1];
        
        NSString * selectedRow =[ [NSString alloc] initWithFormat:@"%i",sender.tag];
        [defaults setObject:state forKey:selectedRow];
    }
    [defaults synchronize];
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
