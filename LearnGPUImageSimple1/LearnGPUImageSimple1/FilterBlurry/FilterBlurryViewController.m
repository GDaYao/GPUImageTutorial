//
//  FilterBlurryViewController.m
//  LearnGPUImageSimple1
//


#import "FilterBlurryViewController.h"

// import
#import <GPUImage/GPUImage.h>

@interface FilterBlurryViewController ()

@property (nonatomic,strong)GPUImageView *mainGPUIV;
@property (nonatomic,strong)GPUImagePicture *gpuIP;
@property (nonatomic,strong)GPUImageTiltShiftFilter *tiltShiftFilter;


@end

@implementation FilterBlurryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self imageFilterBlurryFunction];
    
}

#pragma mark - set filter image
- (void)imageFilterBlurryFunction{
    self.mainGPUIV = [[GPUImageView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mainGPUIV];
    
    UIImage *showImg = [UIImage imageNamed:@"testImg.png"];
    self.gpuIP = [[GPUImagePicture alloc]initWithImage:showImg];
    
    self.tiltShiftFilter = [[GPUImageTiltShiftFilter alloc]init];
    // 模糊度设置
    self.tiltShiftFilter.blurRadiusInPixels = 25.0;
    [self.tiltShiftFilter forceProcessingAtSize:self.mainGPUIV.sizeInPixels];   // 传入全部像素以便操作
    
    [self.gpuIP addTarget:self.tiltShiftFilter];
    [self.tiltShiftFilter addTarget:self.mainGPUIV];
    // start camera
    [self.gpuIP processImage];
    
    
//     GPUImageContext相关数据显示
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    GLint uint = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"log--输出:%d,%d,%d",size,uint,vector);
    
}
#pragma mark touch set filter image
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"log--touchesBegan");
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    float rate = point.y / self.view.frame.size.height;
    
    [self.tiltShiftFilter setTopFocusLevel:rate-0.2];
    [self.tiltShiftFilter setBottomFocusLevel:rate+0.2];

    
    [self.gpuIP processImage];
    
}

#pragma mark - 实现自定义模糊范围 + 模糊程度
- (void)realizedCustomBlurryFrame{
    
    
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end


