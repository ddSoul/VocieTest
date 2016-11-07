//
//  WaveView.m
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "WaveView.h"
#import "MyPoint.h"

@interface WaveView ()

@property (assign, nonatomic) CGFloat pointX;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (nonatomic, strong) NSMutableArray *pointArray;

@end

@implementation WaveView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initConfige];
    }
    
    return self;
}

- (void)initConfige
{
    self.backgroundColor = [UIColor greenColor];
    self.waveWidth = 2.0f;
    self.phaseX = 0.2f;
    self.pointArray = @[].mutableCopy;
}
- (void)setWaveBlock:(void (^)())waveBlock
{
    _waveBlock = waveBlock;
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:_waveBlock selector:@selector(invoke)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setLevel:(CGFloat)level
{
    _level = level*100;
    [self updateMeters];
}

- (void)updateMeters
{
    
    [self.waveShapeLayer removeFromSuperlayer];
    
    MyPoint *tempPoint = [MyPoint new];
    tempPoint.point_X = self.pointX;
    tempPoint.point_Y = self.level;
    [self.pointArray addObject:tempPoint];
    
    //到头了，重新开始吧
    if (self.pointArray.count/5 == self.frame.size.width) {
        [self.pointArray removeAllObjects];
        self.pointX = 0;
        return;
    }
    
    self.bezierPath = [UIBezierPath bezierPath];
    
    //绘制路径
    for (MyPoint * value in self.pointArray) {
        if (value.point_X == 0) {
            [self.bezierPath moveToPoint:CGPointMake(value.point_X, 200 - value.point_Y)];
        }else{
            [self.bezierPath addLineToPoint:CGPointMake(value.point_X, 200 - value.point_Y)];
        }
    }
    
    //初始化shape
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.lineWidth = self.waveWidth;
    self.waveShapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.waveShapeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //
    self.waveShapeLayer.path = self.bezierPath.CGPath;
    [self.layer addSublayer:self.waveShapeLayer];
    self.pointX = self.pointX + self.phaseX;
}

@end
