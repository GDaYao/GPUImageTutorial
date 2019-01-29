//
//  RenderImageViewController.m
//  LearnGPUImageSimple1
//

#import "RenderImageViewController.h"


// 导入GPUImage库
#import <GPUImage/GPUImage.h>

@interface RenderImageViewController ()

@property (nonatomic,strong)UIImageView *testIV;

@end

@implementation RenderImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self testImageView];
}




- (void)testImageView{
    self.testIV = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.testIV];
    
    [self addImageOnGPUImage];
}

#pragma mark - 使用GPUImage
- (void)addImageOnGPUImage{
    GPUImageFilter *filter = [[GPUImageSepiaFilter alloc]init];
    UIImage *image = [UIImage imageNamed:@"testImg.png"];
    if(image){
        self.testIV.image = [filter imageByFilteringImage:image];
    }
    
}


@end
