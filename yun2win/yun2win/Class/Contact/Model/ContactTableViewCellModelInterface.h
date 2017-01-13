//
//  ContactTableViewCellModelInterface.h
//  API
//
//  Created by QS on 16/3/10.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ContactTableViewCellModelInterface <NSObject>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, retain) UIImage *icon;

@property (nonatomic, assign) CGFloat rowHeight;

@end
