//
//  CameraMovieFilterViewController.h
//  LearnGPUImageSimple1
//


// func: 相机录制视频 + 本地视频 叠加一起

/** GPUImage使用类:
 
    GPUImageVideoCamera --- 摄像头录制
 
GPUImageMovie --- 视频播放 + 本地视频或下载视频
    GPUImageMovie类继承了GPUImageOutput类，一般作为响应链的源头，可以通过url、playerItem、asset初始化
 
GPUImageDissolveBlendFilter --- 滤镜
    需要接收两个输入，调用mix方法实现输入混合和比例分配。
 
 
 
    GPUImageView --- 显示
    GPUImageMovieWriter --- 作为输出
 
 
 
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CameraMovieFilterViewController : UIViewController




@end




NS_ASSUME_NONNULL_END
