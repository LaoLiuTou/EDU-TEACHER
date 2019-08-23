//
//  NoteDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface NoteDetailView : UIView
@property (nonatomic,strong) UILabel *nameLabel;//标题 
@property (nonatomic,strong) UILabel *commentLabel;//内容 
@property (nonatomic,strong) NoteModel *noteModel; 
-(int)initModel:(NoteModel *)noteModel type:(NSString *) noteType;
@end
