//
//  SiriViewController.m
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "SiriViewController.h"
#import "SiriView.h"
#import <AVFoundation/AVFoundation.h>

@interface SiriViewController ()

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation SiriViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupRecorder];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    SiriView * waver = [[SiriView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    
    __weak SiriView * weakWaver = waver;
    waver.siriLevelCallback = ^() {
        
        [self.recorder updateMeters];
        
        CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 40);
        
        weakWaver.level = normalizedValue;
        
    };
    [self.view addSubview:waver];
    [self.view addSubview:self.backButton];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)setupRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor redColor];
        _backButton.frame = CGRectMake(30, 20, 100, 50);
        [_backButton setTitle:@"back" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.view.layer removeFromSuperlayer];
    // Dispose of any resources that can be recreated.
}

@end
