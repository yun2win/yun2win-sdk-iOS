//
//  Y2WAudioMessage.h
//  API
//
//  Created by ShingHo on 16/4/21.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WBaseMessage.h"

@interface Y2WAudioMessage : Y2WBaseMessage

@property (nonatomic, copy) NSString *attachmentId;

@property (nonatomic ,copy) NSString *audioPath;

@property (nonatomic ,copy) NSString *audioUrl;

@property (nonatomic, assign) NSInteger audioTimer;

@end
