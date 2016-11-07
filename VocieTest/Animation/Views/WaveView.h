//
//  WaveView.h
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

@property (nonatomic, copy) void (^waveBlock) ();
/**
 线条宽度
 */
@property (nonatomic) CGFloat waveWidth;

/**
 线条颜色
 */
@property (nonatomic) UIColor *waveColor;

/**
 每次更新获取的声音频数
 */
@property (nonatomic) CGFloat level;

/**
 相位移动，可以理解为绘图的x单位
 */
@property (nonatomic) CGFloat phaseX;

@end
