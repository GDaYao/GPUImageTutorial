//
//  CameraWaterMarkViewController.m
//  LearnGPUImageSimple1
//


#import "CameraWaterMarkViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>
// import `GPUImage`
#import <GPUImage/GPUImage.h>


@interface CameraWaterMarkViewController ()
// GPUImage
@property (nonatomic,strong)GPUImageMovie *gpuIM;
@property (nonatomic,strong)GPUImageMovieWriter *gpuMW;
@property (nonatomic,strong)GPUImageDissolveBlendFilter *gpuFilter;
@property (nonatomic,strong)GPUImageView *gpuIV;

// UI
@property (nonatomic,strong)UILabel *showLab;

@end

@implementation CameraWaterMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createWaterMark];
    
    [self createUI];
    
}


#pragma mark - craete UI
- (void)createUI{
    self.showLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 50)];
    self.showLab.textColor = [UIColor redColor];
    [self.view addSubview:self.showLab];
    
}


#pragma mark - create camera and video water mark
- (void)createWaterMark{
    
    self.gpuFilter = [[GPUImageDissolveBlendFilter alloc]init];
    [self.gpuFilter setMix:0.5];
    
    self.gpuIV = [[GPUImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.gpuIV];
    
    
    
    // 制作添加水印
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"我是水印";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    subView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, subView.bounds.size.height / 2);
    [subView addSubview:imageView];
    [subView addSubview:label];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.gpuMW = [[GPUImageMovieWriter alloc]initWithMovieURL:movieURL size:CGSizeMake(640, 480)]; //
    self.gpuMW.shouldPassthroughAudio = YES;
    
    //NSURL *srcURL = [[NSBundle mainBundle] URLForResource:@"play" withExtension:@"mp4"] ;
    NSURL *srcURL = [[NSBundle mainBundle] URLForResource:@"play" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:srcURL];
    self.gpuIM = [[GPUImageMovie alloc]initWithAsset:asset];
    //    self.gpuIM = [[GPUImageMovie alloc]initWithURL:srcURL];
    self.gpuIM.runBenchmark = YES;
    self.gpuIM.playAtActualSpeed = YES;
    self.gpuIM.audioEncodingTarget = self.gpuMW;
    [self.gpuIM enableSynchronizedEncodingUsingMovieWriter:self.gpuMW];
    

    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    
    GPUImageFilter *progressFilter = [[GPUImageFilter alloc]init];
    
    [self.gpuIM addTarget:self.gpuFilter];
    [progressFilter addTarget:self.gpuFilter];
    [uielement addTarget:self.gpuFilter];
    
    [self.gpuFilter addTarget:self.gpuIV];
    [self.gpuFilter addTarget:self.gpuMW];
    
    // start
    [self.gpuMW startRecording];
    [self.gpuIM startProcessing];
    
    
    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
    
    __weak typeof(self) weakSelf = self;
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        CGRect frame = imageView.frame;
        frame.origin.x += 1;
        frame.origin.y += 1;
        imageView.frame = frame;
        [uielement updateWithTimestamp:time];
    }];
    
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
    self.showLab.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(self.gpuIM.progress * 100)];
    [self.showLab sizeToFit];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end




