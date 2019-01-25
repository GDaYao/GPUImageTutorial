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

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"log--initWithCoder");
    
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSLog(@"log--awakeFromNib");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    NSLog(@"log--viewDidLoad");
    
    [self useCameraFilterInGPUImage];
    
    

}


- (void)useCameraFilterInGPUImage{
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    // 捕获声音
//    videoCamera.audioEncodingTarget = movieWriter;
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait ;
    
    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    [videoCamera addTarget:customFilter];
    
    
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds) ,CGRectGetHeight(self.view.bounds) )];
    // 调节fillMode填充模式，改变显示模式。
    filteredVideoView.fillMode = kGPUImageFillModeStretch;  //kGPUImageFillModePreserveAspectRatioAndFill;
    
    
    [customFilter addTarget:filteredVideoView];
    
//    [filter addTarget:filteredVideoView];
    
    
    [videoCamera startCameraCapture];
    
    
}








@end



