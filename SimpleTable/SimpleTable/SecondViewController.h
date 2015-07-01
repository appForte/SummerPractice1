//
//  SecondViewController.h
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFood.h"

@interface SecondViewController : UIViewController
{
    __weak IBOutlet UITextView * _textView;
    __weak IBOutlet UIImageView * _imageView;
    __weak IBOutlet UILabel * _label;
    __weak IBOutlet UIButton * _button;
}
-(id)initSecondView:(STFood*)food;
//@property (nonatomic, strong) IBOutlet UITextView * textView;
@end
