//
//  MeetingCheckCell.h
//  yunTV
//
//  Created by duanhl on 16/11/16.
//  Copyright © 2016年 duanhl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeetingCheckModel;
@class MeetingCheckCell;

#define kMeetingCheckCellH 50.0f

@protocol MeetingCheckDelegate <NSObject>

- (void)meetingCheckCell:(MeetingCheckCell *)cell;

@end

@interface MeetingCheckCell : UITableViewCell

- (void)setupData:(MeetingCheckModel *)model;

@property (weak, nonatomic) id<MeetingCheckDelegate> delegate;

@end
