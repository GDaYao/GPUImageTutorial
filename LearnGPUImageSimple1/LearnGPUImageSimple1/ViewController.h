//
//  ViewController.h
//  LearnGPUImageSimple1
//

// func: GPUImage使用

/** Study - imitate :
 GPUImage-github: https://github.com/BradLarson/GPUImage
 简书学习: https://www.jianshu.com/c/1f71fb708595
 
 1. 处理原图像存储数据 -- 四个输入基础类:按照程序上来说应该是存储的图像或者视频的数据信息继承(NSObject)
 
 ```
    GPUImageVideoCamera 摄像头-视频流
    GPUImageStillCamera 摄像头-照相
    GPUImagePicture 图片
    GPUImageMovie 视频
 ```
 
 2. 进行图像处理 -- use filter - 滤镜过滤
 
 3. 使用GPUImageView加入UIView中显示 -- GPUImageView
 
 // 4. 添加形成target响应连
 
 */



#import <UIKit/UIKit.h>

@interface ViewController : UIViewController




@end




