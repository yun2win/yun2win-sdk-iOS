//
//  NSURL+Y2W.m
//  API
//
//  Created by QS on 16/9/5.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "NSURL+Y2W.h"
#import "Y2WServiceConfig.h"

@implementation NSURL (Y2W)

- (BOOL)isY2WHost {
    return [self.host isEqualToString:[NSURL URLWithString:[Y2WServiceConfig domain]].host];
}

@end
