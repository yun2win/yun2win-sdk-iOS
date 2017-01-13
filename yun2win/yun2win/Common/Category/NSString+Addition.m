//
//  NSString+Addition.m
//  LYY
//
//  Created by QS on 15/3/6.
//  Copyright (c) 2015年 lyy. All rights reserved.
//

#import "NSString+Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Addition)

- (NSString *)first {
    
    if (self.length == 0) return @"";
    return [self substringToIndex:1];
}

- (NSString *)last {
    
    if (self.length == 0) return @"";
    if (self.length == 1) return self;
    return [self substringFromIndex:self.length - 1];
}

- (BOOL)isIntegerNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return[scan scanInteger:&val] && [scan isAtEnd];
}

- (NSInteger)toInteger {
    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[self stringByTrimmingCharactersInSet:nonDigits] integerValue];
}

+ (NSString *)fitConvertSize:(NSInteger)size {
    NSInteger k = 1024, m = 1024 * k, g = 1024 * m;
    if (size / g) {
        return [NSString stringWithFormat:@"%.2fGB",(size * 1.f / g)];
    }
    if (size / m) {
        return [NSString stringWithFormat:@"%.2fMB",(size * 1.f / m)];
    }
    if (size / k) {
        return [NSString stringWithFormat:@"%.2fKB",(size * 1.f / k)];
    }
    return [NSString stringWithFormat:@"%@B",@(size)];
}

- (CGSize)stringSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
}




- (NSString *)MD5Hash {
    
    const char *cstr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (NSString *)MD5HashOfData:(NSData *)data {
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (NSString *)MD5HashOfFile:(NSString *)path {

    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath: path];
    if (handle == nil) {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    
    BOOL done = NO;
    
    while (!done) {
        NSData *fileData = [[NSData alloc] initWithData: [handle readDataOfLength: 4096]];
        CC_MD5_Update (&md5, [fileData bytes], (float)[fileData length]);
        
        if ([fileData length] == 0) {
            done = YES;
        }
    }
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (result, &md5);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}




+ (NSString *)mineTypeOfFile:(NSString *)path {
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

@end
