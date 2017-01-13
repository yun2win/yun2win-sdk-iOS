//
//  ScanViewController.m
//  TV
//
//  Created by yun on 15/10/16.
//  Copyright © 2015年 yun. All rights reserved.
//  扫描二维码页

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import "MyTVModel.h"
#import "TVDeviceSave.h"

#define kBoxViewW 220

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic)AVCaptureVideoPreviewLayer *videoPreviewLayer;//展示layer
@property (strong, nonatomic)AVCaptureSession           *captureSession;   //捕捉会话
@property (nonatomic, strong)MBProgressHUD              *progressHUD;      //提示框
@property (strong, nonatomic)UIView      *viewPreview;   //扫描视图
@property (strong, nonatomic)UIImageView *maskView;      //黑色半透明的蒙层
@property (strong, nonatomic)UIView      *boxView;       //扫描框
@property (strong, nonatomic)CALayer     *scanLayer;     //扫描线
@property (strong, nonatomic)UILabel     *promptLabel;   //提示信息
@property (strong, nonatomic)NSString    *scanValue;     //扫描到的值

@end

@implementation ScanViewController

- (BOOL)hidesBottomBarWhenPushed    {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startReading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewPreview = [[UIView alloc] initWithFrame:self.view.bounds];
    self.title = @"扫一扫";
    CGFloat maskViewW = SCREEN_WIDTH;
    CGFloat maskViewH = SCREEN_HEIGHT - 64.0f;
    self.maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64.0f, maskViewW, maskViewH)];
    NSString *imageNameStr = IS_IPHONE_5 ? @"saomiao_6" : @"saomiao_4";
    self.maskView.image = [UIImage imageNamed:imageNameStr];
    [self.view addSubview:self.viewPreview];
    [self.view addSubview:self.maskView];

    kNavLeft;
    _captureSession = nil;
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

//    //8.1.扫描框
    CGFloat boxViewW = kBoxViewW;
    CGFloat boxViewH = boxViewW;
    CGFloat boxViewX = (SCREEN_WIDTH - boxViewW) / 2.0f;
    CGFloat boxViewY = (SCREEN_HEIGHT - 64.0f - boxViewH) / 2.0f - 33.0f;
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(boxViewX, boxViewY, boxViewW, boxViewH)];
    
    //8.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(2.5, 0, _boxView.bounds.size.width - 5.0f, 1);
    _scanLayer.contents = (id)[UIImage imageNamed:@"saomiaoxian"].CGImage;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    //8.3提示信息 (请将条形码图像置于矩形方框内，系统会自动识别)。
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, boxViewY + boxViewH + 10.0f , SCREEN_WIDTH, 60.0f)];
//    self.promptLabel.text = @"请将条形码图像置于矩形方框内，系统会自动识别";
    self.promptLabel.font = [UIFont systemFontOfSize:13.0f];
    self.promptLabel.backgroundColor = [UIColor clearColor];
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    
    //9.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.bounds];
    
    //10.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    [_boxView.layer addSublayer:_scanLayer];
    [self.maskView addSubview:_boxView];
    [_viewPreview addSubview:self.promptLabel];
    
    //11.设置扫描范围(此处需注意，Y和X是互换的，高和宽是互换的)
    CGFloat rectX = boxViewX / SCREEN_WIDTH;
    CGFloat rectY = boxViewY / (SCREEN_HEIGHT - 64.0f);
    CGFloat rectW = boxViewW / SCREEN_WIDTH;
    CGFloat rectH = boxViewH / (SCREEN_HEIGHT - 64.0f);
    captureMetadataOutput.rectOfInterest = CGRectMake(rectY, rectX, rectH, rectW);

    [timer fire];
    
    //12.开始扫描
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading{
    [self startProgressHUD:@"正在处理中..." time:25.0f];
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);//震动
    [_captureSession stopRunning];
    _captureSession = nil;
    [_boxView removeFromSuperview];
    [_scanLayer removeFromSuperlayer];
    self.promptLabel.text = @"";
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(setupScanValue:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)setupScanValue:(NSString *)str{
    if (str.length <= 0 || [str isEqualToString:self.scanValue]) {
        return;
    }
    
    self.scanValue = str;
    NSData *resData = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:resData options:0 error:&error];
    
    MyTVModel *model = [[MyTVModel alloc] init];
    model.ID = [dict objectForKey:@"ID"];
    model.brand = [dict objectForKey:@"brand"];
    model.connector = [dict objectForKey:@"connector"];
    model.model = [dict objectForKey:@"model"];
    model.state = [dict objectForKey:@"state"];
        
    Y2WCurrentUser *curUser = [Y2WUsers getInstance].currentUser.sessions.user;
    Y2WContact *contact = nil;
    NSArray *array =  [[Y2WUsers getInstance].currentUser.contacts getAllList];
    
    for (Y2WContact *tempContact in array) {
        if ([tempContact.userId isEqualToString:model.ID]) {
            contact = tempContact;
            break;
        }
    }
    
    if (contact) {
        if (self.scanContactBlock) {
            self.scanContactBlock(contact);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        Y2WContact *newContact = [[Y2WContact alloc] init];
        newContact.userId = model.ID;
        newContact.extend = @{@"type":@"device"};
        [curUser.contacts.remote addContact:newContact success:^{
            
            NSDictionary *dic =@{@"type":@"device",
                                 @"b":model.brand,
                                 @"c":model.model};
            NSString *jsonStr = [dic toJsonString];
            
            [[Y2WUsers getInstance].currentUser.sessions.remote getSessionWithTargetId:model.ID type:@"p2p" extend:jsonStr success:^(Y2WSession *session) {
            [self.navigationController popViewControllerAnimated:YES];
        
            } failure:^(NSError *error) {
                [self startProgressHUD:@"操作失败" time:1.0f];
            }];
            
        } failure:^(NSError *error) {
        
            [self startProgressHUD:@"操作失败" time:1.0f];
        }];
    }
    
    [self hudWasHidden:self.progressHUD];
    
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height <= _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//创建一个活动指示器
- (void)startProgressHUD:(NSString *)titleStr time:(CGFloat)time{
    if (self.progressHUD) {
        [self hudWasHidden:self.progressHUD];
    }
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.label.text = titleStr;
    [self.progressHUD hideAnimated:YES afterDelay:time];
}

//活动指示器代理
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [hud removeFromSuperview];
    hud = nil;
}

@end
