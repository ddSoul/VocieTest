//
//  SiriView.m
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "SiriView.h"

@interface SiriView ()

@property (nonatomic) CAGradientLayer *gradientLayer;
@property (nonatomic) CAGradientLayer *gradientLayer_other;
/**
 移动相位
 */
@property (nonatomic) CGFloat phase;

/**
 振幅
 */
@property (nonatomic) CGFloat amplitude;
@property (nonatomic) NSMutableArray * waves;
@property (nonatomic) CGFloat waveHeight;
@property (nonatomic) CGFloat waveWidth;
@property (nonatomic) CGFloat waveMid;
@property (nonatomic) CGFloat maxAmplitude;

@end

@implementation SiriView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initConfige];
    }
    
    return self;
}

- (void)initConfige
{
    
    //主线
    _gradientLayer
    = [CAGradientLayer layer];
    _gradientLayer.frame    = self.bounds;
    _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)[UIColor yellowColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor];
    
    _gradientLayer.locations  = @[@(0.2), @(0.4), @(0.6),@(0.8)];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint  = CGPointMake(1, 0);
    [self.layer addSublayer:_gradientLayer];
    
    //次线
    _gradientLayer_other = [CAGradientLayer layer];
    _gradientLayer_other.frame    = self.bounds;
    _gradientLayer_other.colors = @[(__bridge id)[UIColor greenColor].CGColor,
                                   (__bridge id)[UIColor purpleColor].CGColor,
                                   (__bridge id)[UIColor yellowColor].CGColor,
                                   (__bridge id)[UIColor redColor].CGColor];
    
    _gradientLayer_other.locations  = @[@(0.2), @(0.4), @(0.6),@(0.8)];
    _gradientLayer_other.startPoint = CGPointMake(0, 0);
    _gradientLayer_other.endPoint  = CGPointMake(1, 0);
    [self.layer addSublayer:_gradientLayer_other];
    
    self.waves = [NSMutableArray new];
    
    self.frequency = 1.2f;
    
    self.amplitude = 1.0f;
    self.idleAmplitude = 0.01f;
    
    self.numberOfWaves = 5;
    self.phaseShift = -0.25f;
    self.density = 1.f;
    
    self.waveColor = [UIColor whiteColor];
    self.mainWaveWidth = 5.0f;
    self.decorativeWavesWidth = 3.0f;
    
    self.waveHeight = CGRectGetHeight(self.bounds) * 0.98;
    self.waveWidth  = CGRectGetWidth(self.bounds);
    self.waveMid    = self.waveWidth / 2.0f;
    self.maxAmplitude = self.waveHeight - 4.0f;
}

- (void)setSiriLevelCallback:(void (^)())siriLevelCallback
{
    _siriLevelCallback = siriLevelCallback;
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:_siriLevelCallback selector:@selector(invoke)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    for(int i=0; i < self.numberOfWaves; i++)
    {
        CAShapeLayer *waveline = [CAShapeLayer layer];
        waveline.lineCap       = kCALineCapButt;
        waveline.lineJoin      = kCALineJoinRound;
        waveline.strokeColor   = [[UIColor clearColor] CGColor];
        waveline.fillColor     = [[UIColor clearColor] CGColor];
        [waveline setLineWidth:(i==0 ? self.mainWaveWidth : self.decorativeWavesWidth)];
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
        waveline.strokeColor   = [[UIColor colorWithWhite:1.0 alpha:( i == 0 ? 1.0 : 1.0 * multiplier * 0.4)] CGColor];
        [self.layer addSublayer:waveline];
        [self.waves addObject:waveline];
    }
    
}

- (void)setLevel:(CGFloat)level
{
    _level = level;
    
    self.phase += self.phaseShift; // Move the wave
    
    self.amplitude = fmax( level, self.idleAmplitude);
    
    [self updateMeters];
}


- (void)updateMeters
{
    
    for(int i=0; i < self.numberOfWaves; i++) {
        
        
        UIBezierPath *wavelinePath = [UIBezierPath bezierPath];
        
        CGFloat progress = 1.0f - (CGFloat)i / self.numberOfWaves;
        CGFloat normedAmplitude = (1.5f * progress - 0.5f) * self.amplitude;
        
        
        for(CGFloat x = 0; x<self.waveWidth + self.density; x += self.density) {
            
            CGFloat scaling = -pow(x / self.waveMid  - 1, 2) + 1; // make center bigger
            
            CGFloat y = scaling * self.maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / self.waveWidth) * self.frequency + self.phase) + self.waveHeight - 300;
            
            if (x==0) {
                [wavelinePath moveToPoint:CGPointMake(x, y)];
            }
            else {
                [wavelinePath addLineToPoint:CGPointMake(x, y)];
            }
        }
        
        CAShapeLayer *waveline = [self.waves objectAtIndex:i];
        waveline.path = [wavelinePath CGPath];
        
        if (i == 0) {
            _gradientLayer.mask = waveline;
        }else if(i >= 3){
            _gradientLayer_other.mask = waveline;
        }
        
    }
    
}

@end
