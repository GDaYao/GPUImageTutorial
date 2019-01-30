//
//  CameraVideoFilterViewController.m
//  LearnGPUImageSimple1
//


#import "CameraVideoFilterViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <GPUImage/GPUImage.h>

@interface CameraVideoFilterViewController ()

// GPUImage filter
@property (nonatomic,strong)GPUImageVideoCamera *gpuVC;
@property (nonatomic,strong)GPUImageOutput<GPUImageInput> *gpuFilter;
@property (nonatomic,strong)GPUImageMovieWriter *gpuMW;
@property (nonatomic,strong)GPUImageView *gpuIV;

// create UI
@property (nonatomic , strong) UIButton *cameraBtn;
@property (nonatomic , strong) UILabel  *cameraLab;
@property (nonatomic , assign) long      showLabTime;
@property (nonatomic , strong) NSTimer  *timer;

@property (nonatomic , strong) CADisplayLink *displayLink;


@end

@implementation CameraVideoFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createVideoCameraFilter];
    
    [self setUI];
}


#pragma mark - video camera filter
- (void)createVideoCameraFilter{
    self.gpuVC = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.gpuVC.outputImageOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    
    self.gpuIV = [[GPUImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.gpuIV];
    
    self.gpuFilter = [[GPUImageSepiaFilter alloc]init];
    
    [self.gpuVC addTarget:self.gpuFilter];
    [self.gpuFilter addTarget:self.gpuIV];
    [self.gpuVC startCameraCapture];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.gpuVC.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }];
    
    // 监听屏幕刷新频率 -- 可制作逐帧动画
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}

#pragma mark - setUI
- (void)setUI{
    self.cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.cameraBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cameraBtn.layer.borderWidth = 1.5f;
    [self.cameraBtn setTitle:@"录制" forState:UIControlStateNormal];
    [self.cameraBtn sizeToFit];
    [self.view addSubview:self.cameraBtn];
    [self.cameraBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cameraLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 50, 100)];
    self.cameraLab.hidden = YES;
    self.cameraLab.textColor = [UIColor whiteColor];
    self.cameraLab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cameraLab.layer.borderWidth = 1.5f;
    [self.view addSubview:self.cameraLab];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 40, 100, 40)];
    [slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    slider.value = 0;
    
}


#pragma mark - tartet method
- (void)displaylink:(CADisplayLink *)displaylink {
    NSLog(@"test");
}

- (void)onTimer:(id)sender {
    self.cameraLab.text  = [NSString stringWithFormat:@"录制时间:%lds", self.showLabTime++];
    [self.cameraLab sizeToFit];
}

- (void)onClick:(UIButton *)sender {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    if([sender.currentTitle isEqualToString:@"录制"]) {
        NSLog(@"log -- Start recording");
        [sender setTitle:@"结束" forState:UIControlStateNormal];
        unlink([pathToMovie UTF8String]);    // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
        
        self.gpuMW = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        self.gpuMW.encodingLiveVideo = YES;
        [self.gpuFilter addTarget:self.gpuMW];
        self.gpuVC.audioEncodingTarget = self.gpuMW;
        [self.gpuMW startRecording];
        
        self.showLabTime = 0;
        self.cameraLab.hidden = NO;
        [self onTimer:nil];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    else {
        NSLog(@"log -- End recording");
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        self.cameraLab.hidden = YES;
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self.gpuFilter removeTarget:self.gpuMW];
        self.gpuVC.audioEncodingTarget = nil;
        [self.gpuMW finishRecording];
        
        // 存储系统相册
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
                                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        } // if
        
    } // else
    
    
}

- (void)updateSliderValue:(UISlider *)senderSlider
{
    NSLog(@"log--slider value:%f",[senderSlider value]);
    
    [(GPUImageSepiaFilter *)self.gpuFilter setIntensity:[senderSlider value]];
}







@end



