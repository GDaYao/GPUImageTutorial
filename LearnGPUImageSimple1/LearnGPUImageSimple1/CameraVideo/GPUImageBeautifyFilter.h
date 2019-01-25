//
//  GPUImageBeautifyFilter.h
//  LearnGPUImageSimple1
//

// func: 在相机录制视频的新建类

#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup{
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}


@end

NS_ASSUME_NONNULL_END
