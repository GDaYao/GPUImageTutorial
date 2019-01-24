//
//  CameraFilterViewController.m
//  LearnGPUImageSimple1
//

#import "CameraFilterViewController.h"

// import GPUImage
#import <GPUImage/GPUImage.h>


@interface CameraFilterViewController ()



@end

@implementation CameraFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self useCameraFilterInGPUImage];
    
    

}

- (void)useCameraFilterInGPUImage{
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    // 捕获声音
//    videoCamera.audioEncodingTarget = movieWriter;
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds) ,CGRectGetHeight(self.view.bounds) )];
    
    // Add the view somewhere so it's visible
    
    // 调节fillMode填充模式，改变显示模式。
    filteredVideoView.fillMode = kGPUImageFillModeStretch;  //kGPUImageFillModePreserveAspectRatioAndFill;
    
    
    [videoCamera addTarget:customFilter];
    [customFilter addTarget:filteredVideoView];
    
    [videoCamera startCameraCapture];
    
    
    [self.view addSubview:filteredVideoView];
    
    
}






@end



