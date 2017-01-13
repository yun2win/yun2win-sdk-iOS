//
//  Y2WImagePickerController.m
//  API
//
//  Created by QS on 16/8/19.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "Y2WImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface Y2WImagePickerController ()

@property (nonatomic, copy) void (^handler)(UIImage *image);

@property (nonatomic, copy) void (^videoHandler)(NSString *path, UIImage *image);

@end


@implementation Y2WImagePickerController

- (void)dealloc {
    NSLog(@"释放了");
}

+ (instancetype)pickerWithType:(UIImagePickerControllerSourceType)type handler:(void (^)(UIImage *))handler {
    if(![UIImagePickerController isSourceTypeAvailable:type]) {
        [UIAlertView showTitle:nil message:@"没有权限"];
        return nil;
    }
    return [[Y2WImagePickerController alloc] initWithType:type handler:handler];
}

+ (instancetype)videoPickerWithMaximumDuration:(NSTimeInterval)duration handler:(void (^)(NSString *, UIImage *))handler {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [UIAlertView showTitle:nil message:@"没有权限"];
        return nil;
    }
    return [[Y2WImagePickerController alloc] initWithMaximumDuration:duration handler:handler];
}

- (instancetype)initWithType:(UIImagePickerControllerSourceType)type handler:(void (^)(UIImage *))handler {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.sourceType = type;
        self.delegate = self;
        self.allowsEditing = YES;
        self.handler = handler;
    }
    return self;
}

- (instancetype)initWithMaximumDuration:(NSTimeInterval)duration handler:(void (^)(NSString *, UIImage *))handler {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.mediaTypes = @[(NSString *)kUTTypeMovie];
        self.delegate = self;
        self.allowsEditing = YES;
        self.videoMaximumDuration = duration;
        self.showsCameraControls = YES;
        self.videoHandler = handler;
    }
    return self;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        [library writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [UIAlertView showTitle:nil message:error.message];
                return;
            }
            
            AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
            NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
            
            if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                                      presetName:AVAssetExportPresetPassthrough];
                NSString *path = [NSString tempPathForKey:[[NSUUID UUID].UUIDString stringByAppendingPathExtension:@"mp4"]];
                exportSession.outputURL = [NSURL fileURLWithPath:path];
                exportSession.outputFileType = AVFileTypeMPEG4;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{

                    if (exportSession.status == AVAssetExportSessionStatusCompleted && self.videoHandler) {
                        self.videoHandler(path, [UIImage thumbnailOfVideo:path]);
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            }
        }];
    }
    else {
        NSString *key = self.allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage;
        UIImage *image = [info objectForKey:key];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
            if(originalImage){
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeImageToSavedPhotosAlbum:[originalImage CGImage]
                                          orientation:(ALAssetOrientation)[originalImage imageOrientation]
                                      completionBlock:nil];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if (self.handler) {
                self.handler(image);
            }
        });
    }
}

@end
