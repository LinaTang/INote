//
//  colorViewList.h
//  MyNote
//
//  Created by Ibokan on 16/1/25.
//  Copyright © 2016年 ft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ColorChangeProtocol <NSObject>

-(void)colorChangedWithNewColor:(UIColor *)newColor;

@end

@interface ColorView : UIView


@property(weak, nonatomic)id<ColorChangeProtocol> delegate;


- (instancetype)initWithTarget:(UIViewController *)target;


@end

