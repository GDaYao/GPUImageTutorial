//
//  FilterBlurryViewController.h
//  LearnGPUImageSimple1
//


// func: 对图片模糊处理 -- 用 `GPUImagePicture` 处理源图像，用 `GPUImageTiltShiftFilter` 处理模糊效果，用 `GPUImageView` 显示。

/**
 GPUImage使用类:
    GPUImagePicture -- 操作显示图片
        sizeInPixels 图像像素大小
            {
                pixelSizeOfImage -- 图像存储像素大小
                hasProcessedImage --  图像是否已处理
                imageUpdateSemaphore -- 图像处理的GCD信号量
            }
 
 
    GPUImageTiltShiftFilter：模拟的倾斜移位镜头效果
        blurRadiusInPixels： 模糊程度即像素值 -- 基础模糊的半径，以像素为单位。默认情况下为7.0
        topFocusLevel： 图像中焦点对准区域顶部的标准化位置，此值应低于bottomFocusLevel，默认值为0.4
        bottomFocusLevel：图像中对焦区域底部的标准化位置，此值应高于topFocusLevel，默认值为0.6
        focusFallOffRate：图像模糊远离对焦区域的速率，默认为0.2

 */




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface FilterBlurryViewController : UIViewController







@end

NS_ASSUME_NONNULL_END





