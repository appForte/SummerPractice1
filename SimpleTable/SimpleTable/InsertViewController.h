//
//  InsertViewController.h
//  SimpleTable
//
//  Created by Tekla on 30/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UILabel * _labelMain;
    __weak IBOutlet UILabel * _labelName;
    __weak IBOutlet UILabel * _labelDescripion;
    __weak IBOutlet UILabel * _labelImg;
    
    __weak IBOutlet UITextField * _fieldName;
    __weak IBOutlet UITextField * _fieldDescription;
    __weak IBOutlet UITextField * _fieldImg;
    __weak IBOutlet UIButton * _saveBut;
}
@end
