//
//  ApprovalContentView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/15.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "ApprovalContentView.h"
#import "CXZ.h"


@interface ApprovalContentView ()<RCIMUserInfoDataSource>

@property(nonatomic, strong)UILabel *approvalLabel;

@property(nonatomic, strong)UILabel *replyLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIScrollView *imageScorllview;

@property(nonnull ,strong)NSMutableArray *photoArray;

@end

@implementation ApprovalContentView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _approvalLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 20)];
        _approvalLabel.font = [UIFont systemFontOfSize:12];
        _approvalLabel.textColor = TITLECOLOR;
        [self addSubview:_approvalLabel];
        
        _replyLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, _approvalLabel.bottom, SCREEN_WIDTH-56, 8)];
        _replyLabel.font = [UIFont systemFontOfSize:12];
        _replyLabel.textColor = TITLECOLOR;
        _replyLabel.numberOfLines = 0;
        _replyLabel.isCopyable = YES;
        [self addSubview:_replyLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, frame.size.height-20, SCREEN_WIDTH-16, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = TITLECOLOR;
        [self addSubview:_timeLabel];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickApprovalContentView)];
//        _approvalLabel.userInteractionEnabled = YES;
//        [_approvalLabel addGestureRecognizer:tap];
    }
    return self;
}

-(CGFloat)setApprovalContentWith:(PersonalApprovalResultModel*)model
{
//    NSLog(@"处理  %@",dict);
    
    if (model.approval_state == 1) {
        NSString *agreeStr = [NSString stringWithFormat:@"%@ √同意",model.handler_name];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:agreeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:NSMakeRange(agreeStr.length-3, 3)];
        self.approvalLabel.attributedText = attributedStr;
    }else if(model.approval_state == 2){
        NSString *agreeStr = [NSString stringWithFormat:@"%@ ×不同意",model.handler_name];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:agreeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(agreeStr.length-4, 4)];
        self.approvalLabel.attributedText = attributedStr;
    }
   
   
    self.replyLabel.text = model.opinion;
    if (![NSString isBlankString:model.opinion]) {
        CGSize size = CGSizeMake(self.replyLabel.width,CGFLOAT_MAX);
        CGSize labelsize = [model.opinion sizeWithFont:self.replyLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = self.replyLabel.frame;
        frame.size = labelsize;
        self.replyLabel.frame = frame;
    
//         NSLog(@"label文本高度：%lf",self.replyLabel.height);
        self.timeLabel.top = self.replyLabel.bottom;
    }
    
    self.timeLabel.text = model.handle_time;
    if (![NSString isBlankString:model.picture_enclosure]) {
        NSString *picture = [NSString stringWithFormat:@"%li",[model.picture_enclosure integerValue]];
        if (!_imageScorllview) {
            _imageScorllview = [[UIScrollView alloc]initWithFrame:CGRectMake(self.replyLabel.left, self.replyLabel.bottom, SCREEN_WIDTH-self.replyLabel.left-8, 40)];
            _imageScorllview.showsVerticalScrollIndicator = NO;
            _imageScorllview.showsHorizontalScrollIndicator = YES;
            [self addSubview:_imageScorllview];
            self.timeLabel.top = _imageScorllview.bottom;
        }
        [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":picture} onSucceed:^(NSDictionary *dict) {
           
            if ([dict[@"code"] integerValue]==0) {
                NSArray *imgArray = [dict[@"data"] objectForKey:@"picture"];
                _photoArray = [NSMutableArray array];
                for (int i = 0 ; i < imgArray.count ; i++) {
                    NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imgArray[i]];
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.photoURL = [NSURL URLWithString:pic];
                    [_photoArray addObject:photo];
                    
                     NSString *thum_Image_string = [NSString stringWithFormat:@"%@%@?imageView2/2/w/40/h/40",IMAGE_HOST,imgArray[i]];
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(41*i, 0, 40, 40)];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:thum_Image_string] placeholderImage:nil];
                    imageview.tag = i;
                    [_imageScorllview addSubview:imageview];
                    
                    imageview.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
                    [imageview addGestureRecognizer:tap];
                    
                }
                _imageScorllview.contentSize = CGSizeMake(40*imgArray.count, 40);
            }
        } OnError:^(NSString *error) {
            
        }];
        return self.replyLabel.height+80;
    }
    
    
    return self.replyLabel.height+40;
}

-(CGFloat)setApprovalContentWithDictinary:(NSDictionary*)dict
{
    if ([dict[@"is_agree"] isEqualToString:@"1"]) {
        NSString *agreeStr = [NSString stringWithFormat:@"%@：%@ √同意",dict[@"department_name"],dict[@"name"]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:agreeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:NSMakeRange(agreeStr.length-3, 3)];
        self.approvalLabel.attributedText = attributedStr;
    }else{
        NSString *agreeStr = [NSString stringWithFormat:@"%@：%@ ×不同意",dict[@"department_name"],dict[@"name"]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:agreeStr];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(agreeStr.length-4, 4)];
        self.approvalLabel.attributedText = attributedStr;
    }
    
    NSString *content = [dict objectForKey:@"opinion"];
    self.replyLabel.text = content;
    if (![NSString isBlankString:content]) {
        CGSize size = CGSizeMake(self.replyLabel.width,CGFLOAT_MAX);
        CGSize labelsize = [content sizeWithFont:self.replyLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = self.replyLabel.frame;
        frame.size = labelsize;
        self.replyLabel.frame = frame;
        
        //         NSLog(@"label文本高度：%lf",self.replyLabel.height);
        self.timeLabel.top = self.replyLabel.bottom;
    }
    
    self.timeLabel.text = dict[@"add_time"];
    if (![NSString isBlankString:dict[@"picture"]]) {
        NSString *picture = [NSString stringWithFormat:@"%li",[dict[@"picture"] integerValue]];
        if (!_imageScorllview) {
            _imageScorllview = [[UIScrollView alloc]initWithFrame:CGRectMake(self.replyLabel.left, self.replyLabel.bottom, SCREEN_WIDTH-self.replyLabel.left-8, 40)];
            _imageScorllview.showsVerticalScrollIndicator = NO;
            _imageScorllview.showsHorizontalScrollIndicator = YES;
            [self addSubview:_imageScorllview];
            self.timeLabel.top = _imageScorllview.bottom;
        }
        [[NetworkSingletion sharedManager]getReviewAnnexDetail:@{@"enclosure_id":picture} onSucceed:^(NSDictionary *dict) {
            
            if ([dict[@"code"] integerValue]==0) {
                NSArray *imgArray = [dict[@"data"] objectForKey:@"picture"];
                _photoArray = [NSMutableArray array];
                for (int i = 0 ; i < imgArray.count ; i++) {
                    NSString *pic = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,imgArray[i]];
                    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
                    photo.photoURL = [NSURL URLWithString:pic];
                    [_photoArray addObject:photo];
                    
                    NSString *thum_Image_string = [NSString stringWithFormat:@"%@%@?imageView2/2/w/40/h/40",IMAGE_HOST,imgArray[i]];
                    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(41*i, 0, 40, 40)];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:thum_Image_string] placeholderImage:nil];
                    imageview.tag = i;
                    [_imageScorllview addSubview:imageview];
                    
                    imageview.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
                    [imageview addGestureRecognizer:tap];
                    
                }
                _imageScorllview.contentSize = CGSizeMake(40*imgArray.count, 40);
            }
        } OnError:^(NSString *error) {
            
        }];
        return self.replyLabel.height+80;
    }
    
    
    return self.replyLabel.height+40;

}
-(void)clickImageView:(UITapGestureRecognizer*)tap
{
    NSInteger tag = ((UIImageView*)tap.view).tag;
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = NO;
    pickerBrowser.photos = self.photoArray;
    // 当前选中的值
    pickerBrowser.currentIndex = tag;
    // 展示控制器
    [pickerBrowser showPickerVc:self.viewController];
}


//-(void)clickApprovalContentView
//{
////    [self.delegate chatWithApprovalPeple:self.contentDict];
//   
//    //数据源方法，要传递数据必须加上
//    [[RCIM sharedRCIM] setUserInfoDataSource:self];
//    RCConversationViewController *chat = [[RCConversationViewController alloc] init];
//    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等0
//    chat.conversationType = ConversationType_PRIVATE;
//    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//    chat.targetId =self.contentDict[@"uid"];
//    
//    //设置聊天会话界面要显示的标题
//    chat.title = self.contentDict[@"name"];
//    //显示聊天会话界面
//    chat.hidesBottomBarWhenPushed = YES;
//    [self.viewController.navigationController pushViewController:chat animated:YES];
//}
//#pragma mark - 融云代理 -
//
//
//- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion {
//    
//    //自己的信息
//    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
//    
//    if ([uid isEqualToString:userId]) {
//        
//        RCUserInfo *user = [RCIM sharedRCIM].currentUserInfo;
//        return completion(user);
//    }else{
//        RCUserInfo *user = [[RCDataBaseManager shareInstance]getUserByUserId:userId];
//        if (user) {
//            return completion(user);
//        }else{
//            [[NetworkSingletion sharedManager]getUserInfo:@{@"uid":userId} onSucceed:^(NSDictionary *dict) {
//                
//                if ([dict[@"code"] integerValue]==0) {
//                    NSString* portraitUrl;
//                    NSString *avatar = [dict[@"data"] objectForKey:@"avatar"];
//                    if (![NSString isBlankString:avatar]) {
//                        portraitUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,avatar];
//                    }else{
//                        portraitUrl = @"";
//                    }
//                    NSString *name = [dict[@"data"] objectForKey:@"name"];
//                    if ([NSString isBlankString:name]) {
//                        name = @"";
//                    }
//                    RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:portraitUrl];
//                    //                [ self.dataArray addObject:user];
//                    [[RCDataBaseManager shareInstance] insertUserToDB:user];
//                    return completion(user);
//                    
//                }
//            } OnError:^(NSString *error) {
//            }];
//        }
//        
//    }
//    
//    
//}
//
//



@end
