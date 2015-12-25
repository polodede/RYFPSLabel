//
//  RYFPSLabel.m
//  Pods
//
//  Created by Ryan on 15/12/25.
//
//

#import "RYFPSLabel.h"

#define kLabelRect CGRectMake(0, 20, 100, 24)

@interface RYFPSLabel ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimeStamp;
@property (nonatomic, assign) NSInteger count;

@end

@implementation RYFPSLabel

+ (void)install{
    RYFPSLabel *fpsLabel = [RYFPSLabel sharedInstance];
    [[UIApplication sharedApplication].keyWindow addSubview:fpsLabel];
    
}

+ (instancetype)sharedInstance{
    static RYFPSLabel *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RYFPSLabel alloc] initWithFrame:kLabelRect];
    });
    return instance;
}

- (void)dealloc{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4;
        self.userInteractionEnabled = NO;
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        self.textColor = [UIColor whiteColor];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calFPS:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)calFPS:(CADisplayLink *)link{
    if (_lastTimeStamp == 0) {
        _lastTimeStamp = link.timestamp;
        return;
    }
    
    _count++;
    
    NSTimeInterval offsetTimeStamp = link.timestamp - _lastTimeStamp;
    
    if (offsetTimeStamp < 1) return;
    _lastTimeStamp = link.timestamp;
    float fps = _count / offsetTimeStamp;
    
    _count = 0;
    
    NSString *fpsText = [NSString stringWithFormat:@"FPS: %d",(int)round(fps)];
    self.text = fpsText;
}

@end
