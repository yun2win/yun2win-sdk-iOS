//
//  MessageCellModelInterface.h
//  API
//
//  Created by QS on 16/3/17.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "MessageCellDelegate.h"

@protocol MessageCellModelInterface <NSObject>

@property (nonatomic, weak)   id<MessageCellDelegate> messageDelegate;


- (void)refreshData:(MessageModel *)data;


@end
