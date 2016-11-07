//
//  WaveViewController.m
//  VocieTest
//
//  Created by ddSoul on 16/11/7.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "WaveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "IQAudioRecorderConstraints.h"
#import "AnimationViews.h"

@interface WaveViewController ()
{
    
    //Recording...
    AVAudioRecorder *_audioRecorder;
    NSString *_recordingFilePath;
    CADisplayLink *meterUpdateDisplayLink;
    
    //Playing
    AVAudioPlayer *_audioPlayer;
    
    //Recording controls
    BOOL _isRecordingPaused;
    
    //Private variables
    NSString *_oldSessionCategory;
    
}
/**
 Maximum duration of the audio file to be recorded.
 */
@property(nonatomic) NSTimeInterval maximumRecordDuration;

/**
 Audio format. default is IQAudioFormat_m4a.
 */
@property(nonatomic,assign) IQAudioFormat audioFormat;

/**
 sampleRate should be floating point in Hertz.
 */
@property(nonatomic,assign) CGFloat sampleRate;

/**
 Number of channels.
 */
@property(nonatomic,assign) NSInteger numberOfChannels;

/**
 Audio quality.
 */
@property(nonatomic,assign) IQAudioQuality audioQuality;

/**
 bitRate.
 */
@property(nonatomic,assign) NSInteger bitRate;

@property (nonatomic, strong) AnimationViews *animationVies;


- (IBAction)starButton:(UIButton *)sender;
- (IBAction)stopButton:(UIButton *)sender;
- (IBAction)backButton:(UIButton *)sender;

@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.animationVies];
    [self setRecorder];
    [self startUpdatingMeter];
}

//AVAudioRecorder 的一些设置，参考的
- (void)setRecorder{
    {
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        
        NSString *globallyUniqueString = [NSProcessInfo processInfo].globallyUniqueString;
        
        if (self.audioFormat == IQAudioFormatDefault || self.audioFormat == IQAudioFormat_m4a)
        {
            _recordingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",globallyUniqueString]];
            
            recordSettings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
        }
        else if (self.audioFormat == IQAudioFormat_caf)
        {
            _recordingFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf",globallyUniqueString]];
            
            recordSettings[AVFormatIDKey] = @(kAudioFormatAppleLossless);
        }
        
        if (self.sampleRate > 0.0f)
        {
            recordSettings[AVSampleRateKey] = @(self.sampleRate);
        }
        else
        {
            recordSettings[AVSampleRateKey] = @44100.0f;
        }
        
        if (self.numberOfChannels >0)
        {
            recordSettings[AVNumberOfChannelsKey] = @(self.numberOfChannels);
        }
        else
        {
            recordSettings[AVNumberOfChannelsKey] = @1;
        }
        
        if (self.audioQuality != IQAudioQualityDefault)
        {
            recordSettings[AVEncoderAudioQualityKey] = @(self.audioQuality);
        }
        
        if (self.bitRate > 0)
        {
            recordSettings[AVEncoderBitRateKey] = @(self.bitRate);
        }
        
        // Initiate and prepare the recorder
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_recordingFilePath] settings:recordSettings error:nil];
        _audioRecorder.meteringEnabled = YES;
        
    }
    
}

-(void)startUpdatingMeter
{
    [meterUpdateDisplayLink invalidate];
    meterUpdateDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    meterUpdateDisplayLink.frameInterval = 1;
    [meterUpdateDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
//更新
- (void)updateMeters
{
    
    if (_audioRecorder.isRecording || _isRecordingPaused)
    {
        [_audioRecorder updateMeters];
        
        CGFloat normalizedValue = pow (10, [_audioRecorder averagePowerForChannel:0] / 20);
        
        [self.animationVies animationAddPointY:normalizedValue * 150];
        
    }
}


- (AnimationViews *)animationVies
{
    if (!_animationVies) {
        _animationVies = [[AnimationViews alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)];
    }
    return _animationVies;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [meterUpdateDisplayLink invalidate];
    [self.animationVies.layer removeFromSuperlayer];
    // Dispose of any resources that can be recreated.
}



- (IBAction)starButton:(UIButton *)sender {
    /*
     Create the recorder
     */
    if ([[NSFileManager defaultManager] fileExistsAtPath:@""])
    {
        [[NSFileManager defaultManager] removeItemAtPath:@"" error:nil];
    }
    
    _oldSessionCategory = [AVAudioSession sharedInstance].category;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [_audioRecorder prepareToRecord];
    
    _isRecordingPaused = YES;
    
    if (self.maximumRecordDuration <=0)
    {
        [_audioRecorder record];
    }
    else
    {
        [_audioRecorder recordForDuration:self.maximumRecordDuration];
    }

}

- (IBAction)stopButton:(UIButton *)sender {
    _isRecordingPaused = NO;
    [_audioRecorder stop];
}

- (IBAction)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
