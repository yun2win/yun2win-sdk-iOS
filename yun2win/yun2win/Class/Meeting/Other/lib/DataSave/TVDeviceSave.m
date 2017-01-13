//
//  TVDeviceSave.m
//  yun2win
//
//  Created by duanhl on 16/11/23.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "TVDeviceSave.h"
#import "MyTVModel.h"

@implementation TVDeviceSave

+ (void)DataSave:(MyTVModel *)model
{
    if (!model) { return; }
    /*----------存储历史----------*/
    NSString *path = [kSaveModelPath stringByAppendingPathComponent:kSaveHistoryName];
    NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
    [historyArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
    
    BOOL isRepeat = NO;
    //判断是否有重复的
    for (MyTVModel *hisModel in historyArray) {
        if ([hisModel.ID isEqualToString:model.ID]) {
            isRepeat = YES;
            break;
        }
    }
    
    if (!isRepeat) {
        [historyArray addObject:model];
        //获得文件的全路径
        NSString *path = [kSaveModelPath stringByAppendingPathComponent:kSaveHistoryName];
        //将对象归档
        [NSKeyedArchiver archiveRootObject:historyArray toFile:path];
    }
}

//获取所有的数据
+ (NSArray *)getAllTV {
    NSString *path = [kSaveModelPath stringByAppendingPathComponent:kSaveHistoryName];
    NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:0];
    [historyArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
    
    return [historyArray copy];
}

//删除-个TV数据
+ (void)DataDelete:(NSString *)ID
{
    if (!ID && ID.length > 0) { return; }
    /*----------取出历史----------*/
    NSString *path = [kSaveModelPath stringByAppendingPathComponent:kSaveHistoryName];
    //从文件中取出历史记录组数
    NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:1];
    [historyArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
    
    for (int i = 0; i < historyArray.count; i++) {
        
        MyTVModel *model = [historyArray objectAtIndex:i];
        
        if ([model.ID isEqualToString:ID]) {
            [historyArray removeObjectAtIndex:i];
            //将对象归档
            [NSKeyedArchiver archiveRootObject:historyArray toFile:path];
        }
    }
}

////修改TV名称
//+ (void)DataDeviceId:(NSString *)ID nickName:(NSString *)nickName
//{
//    if (!ID || !nickName) { return; }
//    
//    /*----------取出历史----------*/
//    NSString *path = [kSaveModelPath stringByAppendingPathComponent:kSaveHistoryName];
//    //从文件中取出历史记录组数
//    NSMutableArray *historyArray = [NSMutableArray arrayWithCapacity:1];
//    [historyArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:path]];
//    
//    //查找
//    for (int i = 0; i < historyArray.count; i++) {
//        
//        MyTVModel *model = [historyArray objectAtIndex:i];
//        
//        if ([model.ID isEqualToString:ID]) {
//            
//            [historyArray removeObjectAtIndex:i];
//            
//            model.name = nickName;
//            [historyArray insertObject:model atIndex:i];
//            
//            //将对象归档
//            [NSKeyedArchiver archiveRootObject:historyArray toFile:path];
//            
//            break;
//        }
//    }
//}

@end
