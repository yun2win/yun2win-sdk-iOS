//
//  Y2WContactsDelegate.h
//  API
//
//  Created by QS on 16/3/30.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Y2WContacts,Y2WContact;
@protocol Y2WContactsDelegate <NSObject>
@optional

/**
 *  联系人变化完成的回调
 *
 *  @param contacts 联系人管理对象
 */
- (void)contactsDidChangeContent:(Y2WContacts *)contacts;

@end
