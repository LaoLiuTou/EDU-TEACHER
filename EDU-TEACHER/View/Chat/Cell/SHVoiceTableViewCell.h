//
//  SHVoiceTableViewCell.h

//

#import "SHMessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/**
 语音消息Cell
 */
@interface SHVoiceTableViewCell : SHMessageTableViewCell

// 正在播放 0 未播放 1 播放中
// 播放 YES 未播放 NO
@property (nonatomic, assign) BOOL isPlaying;

//播放语音动画
- (void)playVoiceAnimation;
//停止语音动画
- (void)stopVoiceAnimation;

@end

NS_ASSUME_NONNULL_END
