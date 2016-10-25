//
//  AnimationViews.m
//  VocieTest
//
//  Created by 邓西亮 on 16/10/25.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "AnimationViews.h"
#import "MyPoint.h"

@interface AnimationViews ()

@property (assign, nonatomic) CGFloat pointX;
@property (strong, nonatomic) CAShapeLayer *waveShapeLayer;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (nonatomic, strong) NSMutableArray *pointArray;

@end

@implementation AnimationViews

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.frame = frame;
        [self createControls];
    }
    return self;
}

/**
 * 创建控件
 */
- (void)createControls
{
    self.backgroundColor = [UIColor greenColor];
    self.pointArray = @[].mutableCopy;

}


- (void)animationAddPointY:(CGFloat)pointY
{
    [self.waveShapeLayer removeFromSuperlayer];
    
    self.pointX = self.pointX + 0.2;
    MyPoint *tempPoint = [MyPoint new];
    tempPoint.point_X = self.pointX;
    tempPoint.point_Y = pointY;
    [self.pointArray addObject:tempPoint];
    
    //到头了，重新开始吧
    if (self.pointArray.count/5 == self.frame.size.width) {
        [self.pointArray removeAllObjects];
        self.pointX = 0;
    }
    
    self.bezierPath = [UIBezierPath bezierPath];
    [self.bezierPath moveToPoint:CGPointMake(self.frame.size.width, 200)];
    
    for (MyPoint * value in self.pointArray) {
        [self.bezierPath addLineToPoint:CGPointMake(value.point_X, 200 - value.point_Y)];
    }
    
    self.waveShapeLayer = [CAShapeLayer layer];
    self.waveShapeLayer.lineWidth = 2;
    self.waveShapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.waveShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    
    [self.layer addSublayer:self.waveShapeLayer];
    
    self.waveShapeLayer.path = self.bezierPath.CGPath;
    
}

@end
