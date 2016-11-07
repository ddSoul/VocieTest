//
//  SiriView.h
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiriView : UIView

@property (nonatomic, copy) void (^siriLevelCallback)();

/**
 线条数量
 */
@property (nonatomic) NSUInteger numberOfWaves;

/**
 线条颜色
 */
@property (nonatomic) UIColor * waveColor;

/**
 每次更新获取的声音频数
 */
@property (nonatomic) CGFloat level;

/**
 主线条宽度
 */
@property (nonatomic) CGFloat mainWaveWidth;

/**
 后线条的宽度
 */
@property (nonatomic) CGFloat decorativeWavesWidth;

/**
 后面的线条振幅
 */
@property (nonatomic) CGFloat idleAmplitude;

/**
 频率
 */
@property (nonatomic) CGFloat frequency;

/**
 振幅
 */
@property (nonatomic, readonly) CGFloat amplitude;


/**
 密度
 */
@property (nonatomic) CGFloat density;


/**
 相位移动
 */
@property (nonatomic) CGFloat phaseShift;

/**
 线条数组
 */
@property (nonatomic, readonly) NSMutableArray * waves;


@end
