//
//  SHImageTableViewCell.m

//

#import "SHImageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SHImageTableViewCell ()

//bubble imgae
@property (nonatomic, retain) UIImageView *chatImage;

@end
@implementation SHImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageFrame:(SHMessageFrame *)messageFrame{
    [super setMessageFrame:messageFrame];
    
    SHMessage *message = messageFrame.message;

    
    // 设置聊天气泡背景
    UIImage *qpimage = nil;
    // 设置聊天气泡背景
    if (self.isSend) {
        qpimage = [SHFileHelper imageNamed:@"chat_message_send@2x.png"];
    }else{
        qpimage = [SHFileHelper imageNamed:@"chat_message_receive@2x.png"];
    }
    
    qpimage = [qpimage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 25, 10, 25)];
    [self.btnContent setBackgroundImage:qpimage forState:UIControlStateNormal];
    
    
    
    //self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
    //[self.btnContent makeMaskView:self.btnContent image:qpimage];
    //编辑气泡
    [self.btnContent makeMaskView:[self chatImage:message] image:qpimage];
}
 
- (UIImageView *)chatImage:(SHMessage *)message{
    //背景
    if (!_chatImage) {
         
        _chatImage = [[UIImageView alloc]init];
      
        NSString *filePath = [SHFileHelper getFilePathWithName:message.imageName type:SHMessageFileType_image];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image) {//本地
             [_chatImage setImage:image];
        }else{//网络
            [_chatImage sd_setImageWithURL:[NSURL URLWithString:message.imageUrl]];
        }
        _chatImage.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
        //_chatImage.frame = CGRectMake(0, 0, 100, 120);
        _chatImage.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.btnContent addSubview:_chatImage];
    }
    return _chatImage;
}

@end
