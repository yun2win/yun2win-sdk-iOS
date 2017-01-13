//
//  CLPlacemark+Addtion.m
//  yun2win
//
//  Created by QS on 16/10/24.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "CLPlacemark+Addtion.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation CLPlacemark (Addtion)

- (NSString *)formattedAddress {
    NSString *address = ABCreateStringWithAddressDictionary(self.addressDictionary,YES);
    unichar characters[1] = {0x200e};
    NSString *invalidString = [[NSString alloc]initWithCharacters:characters length:1];
    NSString *formattedName =  [[address stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                                stringByReplacingOccurrencesOfString:invalidString withString:@""];
    return formattedName;
}

@end
