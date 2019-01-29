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

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//
//    NSLog(@"log--initWithCoder");
//
//    return self;
//}
//
//- (void)awakeFromNib{
//    [super awakeFromNib];
//
//    NSLog(@"log--awakeFromNib");
//
//}


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
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;  // 正摄像头
    
    
    
    GPUImageView *gpuIV = [[GPUImageView alloc] initWithFrame:self.view.frame];
    gpuIV.center = self.view.center;
    // 调节fillMode填充模式，改变显示模式。
    gpuIV.fillMode = kGPUImageFillModeStretch;  //kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview:gpuIV];


    [videoCamera startCameraCapture];

    
    GPUImageSepiaFilter *customFilter = [[GPUImageSepiaFilter alloc] init];
    //GPUImageFilter *customFilter = [[GPUImageFilter alloc] init]; // WithFragmentShaderFromFile:@"CustomShader"
    [videoCamera addTarget:customFilter];
    [customFilter addTarget:gpuIV];
    
    
}








@end



