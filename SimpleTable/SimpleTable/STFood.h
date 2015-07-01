//
//  STFood.h
//  SimpleTable
//
//  Created by Tekla on 29/06/15.
//  Copyright (c) 2015 Tekla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STFood : NSObject
{
    NSString * name;
    NSString * imageName;
    int ind;
}
@property (nonatomic,strong) NSString* name,*imageName;
@property (nonatomic,assign) int ind;
@end
