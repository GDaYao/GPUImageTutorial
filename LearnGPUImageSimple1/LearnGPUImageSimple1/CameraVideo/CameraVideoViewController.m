//
//  CameraVideoViewController.m
//  LearnGPUImageSimple1
//

#import "CameraVideoViewController.h"

#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GPUImageBeautifyFilter.h"



@interface CameraVideoViewController ()

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, strong) GPUImageView *filterIV;

@end

@implementation CameraVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self cameraVideoInGPUImage];
    
}



- (void)cameraVideoInGPUImage{
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.audioEncodingTarget = _movieWriter;
    
    self.filterIV = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterIV.center = self.view.center;
    [self.view addSubview:self.filterIV];
    
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0, 480.0)];
    
    self.movieWriter.encodingLiveVideo = YES;
    [self.videoCamera startCameraCapture];
    
    
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:self.filterIV];
    [beautifyFilter addTarget:self.movieWriter];
    [self.movieWriter startRecording];
    
    /*   上面-已经显示的录制实时显示   */
    
    
    
    /*    下面-可保存录制视频至本地
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [beautifyFilter removeTarget:self.movieWriter];
        [self.movieWriter finishRecording];
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
    });
     
      */
    
    
    
    
}





@end



