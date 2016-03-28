//
//  NoteTableViewCell.m
//  MyNote
//
//  Created by ft on 16/2/22.
//  Copyright © 2016年 fft1026@163.com All rights reserved.
//

#import "NoteTableViewCell.h"

@implementation NoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


//重写set方法
- (void)setNote:(Note *)note {

    //remove掉contentView中所有的子视图,防止重用
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //设置主标签显示内容
    self.textLabel.text = [note.attributedContent string];
    
    //设置详情标签显示内容
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    self.detailTextLabel.text = [dateFormatter stringFromDate:note.date];
    
    //设置cell的标签颜色
    UILabel *statusLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    statusLB.center = CGPointMake(CGRectGetWidth(self.frame) - 35, CGRectGetMidY(self.bounds));        //注意:使用bounds值
    statusLB.layer.cornerRadius = 9;
    statusLB.layer.masksToBounds = YES;
    statusLB.backgroundColor = [note.dict objectForKey:@"color"];
    [self.contentView addSubview:statusLB];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
