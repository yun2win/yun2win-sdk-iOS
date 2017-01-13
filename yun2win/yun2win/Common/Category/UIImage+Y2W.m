//
//  UIImage+Y2W.m
//  API
//
//  Created by QS on 16/9/13.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "UIImage+Y2W.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface UIColorCache : NSObject
@property (nonatomic,strong)    NSCache *colorImageCache;
@end

@implementation UIColorCache

+ (instancetype)sharedCache {
    static UIColorCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UIColorCache alloc] init];
        instance.colorImageCache = [[NSCache alloc] init];
    });
    return instance;
}

- (UIImage *)image:(UIColor *)color {
    return color ? [_colorImageCache objectForKey:[color description]] : nil;
}

- (void)setImage:(UIImage *)image forColor:(UIColor *)color {
    [_colorImageCache setObject:image forKey:[color description]];
}

@end


@implementation UIImage (Y2W)

- (UIImage *)imageWithScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)imageWithSize:(CGSize)reSize {
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [self drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

- (UIImage *)imageWithRect:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage *image = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return image;
}

+ (UIImage *)imageWithUIColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    UIImage *image = [[UIColorCache sharedCache] image:color];
    if (image) {
        return image;
    }
    CGFloat alphaChannel;
    [color getRed:NULL green:NULL blue:NULL alpha:&alphaChannel];
    BOOL opaqueImage = (alphaChannel == 1.0);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaqueImage, [UIScreen mainScreen].scale);
    [color setFill];
    UIRectFill(rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UIColorCache sharedCache] setImage:image forColor:color];
    return image;
}

+ (UIImage *)y2w_imageNamed:(NSString *)name {
    UIImage *image = [SDWebImageManager.sharedManager.imageCache imageFromMemoryCacheForKey:name];
    if (!image) {
        image = [UIImage imageNamed:name];
        [SDWebImageManager.sharedManager.imageCache storeImage:image forKey:name toDisk:NO];
    }
    return image;
}

+ (UIImage *)y2w_animatedGIFNamed:(NSString *)name {
    UIImage *image = [UIImage y2w_imageNamed:name];
    if (!image) {
        image = [UIImage sd_animatedGIFNamed:name];
        [SDWebImageManager.sharedManager.imageCache storeImage:image forKey:name toDisk:NO];
    }
    return image;
}

+ (UIImage *)thumbnailOfVideo:(NSString *)videoPath {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0, 60); // 参数( 截取的秒数， 视频每秒多少帧)
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (NSString *)writePNG {
    NSData *data = UIImagePNGRepresentation(self);
    NSString *path = [NSString tempPathForKey:[NSString MD5HashOfData:data]];
    [data writeToFile:path atomically:YES];
    return path;
}

- (NSString *)writeJPGToQuality:(CGFloat)quality {
    NSData *data = UIImageJPEGRepresentation(self, quality);
    NSString *path = [NSString tempPathForKey:[NSString MD5HashOfData:data]];
    [data writeToFile:path atomically:YES];
    return path;
}

- (UIImage *)scaleToAvatar {
    return [self imageWithSize:CGSizeMake(256, 256)];
}

@end
