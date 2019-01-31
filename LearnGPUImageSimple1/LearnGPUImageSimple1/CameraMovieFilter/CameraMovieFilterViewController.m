//
//  CameraMovieFilterViewController.m
//  LearnGPUImageSimple1
//


#import "CameraMovieFilterViewController.h"


#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface CameraMovieFilterViewController ()

@property (nonatomic,strong)GPUImageMovie *gpuMovie;
@property (nonatomic,strong)GPUImageVideoCamera *gpuVC;
@property (nonatomic,strong)GPUImageDissolveBlendFilter *gpuFilter;
@property (nonatomic,strong)GPUImageView *gpuIV;
@property (nonatomic,strong)GPUImageMovieWriter *gpuMW;


// create UI
@property (nonatomic,strong)UILabel *lab;

@end

@implementation CameraMovieFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createCameraMovieFilter];
    
    [self createMovieUI];
    
}


- (void)createMovieUI{
    
    self.lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    self.lab.textColor = [UIColor redColor];
    [self.view addSubview:self.lab];    
    
}


#pragma mark - create camera movie filter
- (void)createCameraMovieFilter{
    
    NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"play" withExtension:@"mp4"];
    self.gpuMovie = [[GPUImageMovie alloc]initWithURL:movieURL];
    self.gpuMovie.runBenchmark = YES;
    self.gpuMovie.playAtActualSpeed = YES;
    
    
    self.gpuFilter = [[GPUImageDissolveBlendFilter alloc]init];
    [self.gpuFilter setMix:0.5]; // 设置混合度
    
    
    self.gpuIV = [[GPUImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.gpuIV];

    
    self.gpuVC = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.gpuVC.outputImageOrientation = [[UIApplication sharedApplication]statusBarOrientation];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *saveURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.gpuMW = [[GPUImageMovieWriter alloc]initWithMovieURL:saveURL size:CGSizeMake(640.0, 480.0)];
    [self.gpuMW setAudioProcessingCallback:^(SInt16 **samplesRef, CMItemCount numSamplesInBuffer) {
//        NSLog(@"log--setAudioProcessingCallback");
    }];
    
    BOOL audioFromFile = NO;
    // 形成响应链
    if (audioFromFile) {
        [self.gpuMovie addTarget:self.gpuFilter];
        [self.gpuVC addTarget:self.gpuFilter];
        
        self.gpuMW.shouldPassthroughAudio = YES; // 是否使用源音源。
        self.gpuMovie.audioEncodingTarget = self.gpuMW; // 设置本地视频显示--音频文件来源
        [self.gpuMovie enableSynchronizedEncodingUsingMovieWriter:self.gpuMW];
    }else{
        [self.gpuMovie  addTarget:self.gpuFilter];
        [self.gpuVC addTarget:self.gpuFilter];
        
        self.gpuVC.audioEncodingTarget = self.gpuMW; // 设置摄像头录制使用
        self.gpuMW.shouldPassthroughAudio = NO; //
        self.gpuMW.encodingLiveVideo = NO;
    } // else
    
    [self.gpuFilter addTarget:self.gpuIV];
    [self.gpuFilter addTarget:self.gpuMW];
    // 开始录制、记录、处理 -- 响应链输入
    [self.gpuVC startCameraCapture];
    [self.gpuMW startRecording];
    [self.gpuMovie startProcessing];
    
    // 记录帧频率
    CADisplayLink *disLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [disLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [disLink setPaused:NO];
    
    // GPUImageMovieWrite输出结束回调
    __weak typeof(self) weakSelf = self;
    [self.gpuMW setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.gpuFilter removeTarget:strongSelf.gpuMW];
        [strongSelf.gpuMW finishRecording];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    }];
    
}


- (void)updateProgress
{
    self.lab.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.gpuMovie.progress * 100)];
    [self.lab sizeToFit];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}







@end



