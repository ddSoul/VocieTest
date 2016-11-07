//
//  HomeViewController.m
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "HomeViewController.h"
#import "SiriViewController.h"
#import "WaveViewController.h"

@interface HomeViewController ()
- (IBAction)siriButton:(UIButton *)sender;
- (IBAction)waveButton:(UIButton *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)siriButton:(UIButton *)sender {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    SiriViewController *preVc = [[SiriViewController alloc] init];
    [self presentViewController:preVc animated:YES completion:nil];
    
}

- (IBAction)waveButton:(UIButton *)sender {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    WaveViewController *preVc = [[WaveViewController alloc] init];
    [self presentViewController:preVc animated:YES completion:nil];
}
@end
