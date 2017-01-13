//
//  MessageCell.m
//  API
//
//  Created by QS on 16/3/14.
//  Copyright © 2016年 yun2win. All rights reserved.
//

#import "MessageCell.h"
#import "Y2WUsers.h"

@interface MessageCell (){
    UILongPressGestureRecognizer *_longPressGesture;
}

@property (nonatomic, retain) MessageModel *model;

@property (nonatomic, retain) NSMutableDictionary *bubbleViews;

@end

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.retryButton];
        [self.contentView addSubview:self.indicator];
        [self.contentView addSubview:self.readedButton];
        [self.contentView addSubview:self.bubbleView];
        [self makeGesture];
    }
    return self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:_longPressGesture];
}

- (void)makeGesture{
    _longPressGesture= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesturePress:)];
    [self addGestureRecognizer:_longPressGesture];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self layoutTimeStamp];
    [self layoutAvatar];
    [self layoutNameLabel];
    [self layoutBubbleView];
    [self layoutIndicator];
    [self layoutRetryButton];
    [self layoutReadedButton];
}

- (void)layoutTimeStamp {
    
    BOOL needShow = [self needShowTimeStamp];
    _timeLabel.hidden = !needShow;
    if (needShow) {
        _timeLabel.frame = CGRectMake(0, 6, self.width, self.model.cellConfig.timeStampHeight);
    }
}

- (void)layoutAvatar {
    
    BOOL needShow = [self needShowAvatar];
    self.headImageView.hidden = !needShow;
    if (needShow) {
        self.headImageView.frame = self.model.avatarFrame;
        self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    }
}

- (void)layoutNameLabel {
    
    BOOL needShow = [self needShowNickName];
    self.nameLabel.hidden = !needShow;
    if (needShow) {
        [self.nameLabel sizeToFit];
        self.nameLabel.height = 15;
        self.nameLabel.centerX = self.headImageView.centerX;
        self.nameLabel.top = self.headImageView.top + self.headImageView.height + 2;
    }
}

- (void)layoutBubbleView {
    
    self.bubbleView.frame = self.model.contentFrame;
}

- (void)layoutIndicator {
    
    BOOL needShow = [self needShowIndicator];
    _indicator.hidden = !needShow;
    if (needShow) {
        _indicator.center = CGPointMake(self.bubbleView.left - _indicator.width/2 - 8,
                                        self.bubbleView.top + self.bubbleView.height/2);
    }
}

- (void)layoutRetryButton {
    
    BOOL needShow = [self needShowRetryButton];
    _retryButton.hidden = !needShow;
    if (needShow) {
        _retryButton.center = CGPointMake(self.bubbleView.left - _retryButton.width/2 - 8,
                                          self.bubbleView.top + self.bubbleView.height/2);
    }
}

- (void)layoutReadedButton {
    
    BOOL needShow = [self needShowReadedButton];
    _readedButton.hidden = !needShow;
    if (needShow) {
        _readedButton.center = CGPointMake(self.bubbleView.left - _readedButton.width/2 - 5,
                                           self.bubbleView.top + self.bubbleView.height/2);
    }
}



#pragma mark - ———— Helper ———— -

- (BOOL)needShowTimeStamp {
    return self.model.shouldShowTimeStamp;
}

- (BOOL)needShowAvatar {
    return YES;
}

- (BOOL)needShowNickName {
    return [self.model.member.sessionMembers.session.type isEqualToString:@"p2p"] ? NO :(self.model.isMe) ? NO : YES;
}

- (BOOL)needShowIndicator {
    if (!self.model.isMe) return NO;
    
    if (self.model.status == MessageModelStatusSending) return YES;
    return NO;
}

- (BOOL)needShowRetryButton {
    if (!self.model.isMe) return NO;

    if (self.model.status == MessageModelStatusSendFailed) return YES;
    return NO;
}

- (BOOL)needShowReadedButton {
    if ([self needShowIndicator] ||
        [self needShowRetryButton]) {
        return NO;
    }
    return self.model.isShowReaded;
}



#pragma mark - ———— Model ———— -

- (void)refreshData:(MessageModel *)data {
    _model = data;
    
    if ([self needShowTimeStamp]) {
        
        [_timeLabel setDate:data.message.updatedAt.y2w_toDate];
    }
    
    if ([self needShowAvatar]) {
        [_headImageView setBackgroundColor:[UIColor colorWithUID:data.member.userId]];
        [_headImageView y2w_setImageForState:UIControlStateNormal withY2WURLString:data.member.getAvatarUrl placeholderImage:[UIImage y2w_imageNamed:@"默认个人头像"]];
    }
    
    if([self needShowNickName]) {
        
        [self.nameLabel setText:data.member.name];
    }

    
    [self.bubbleView refreshData:_model];
    
    
    if ([self needShowIndicator]) {
        
        [_indicator startAnimating];
        
    }else {
        
        [_indicator stopAnimating];
    }

    [self setNeedsLayout];
}






#pragma mark - Action

- (void)onTapAvatar:(id)sender {
    if ([_messageDelegate respondsToSelector:@selector(onTapAvatar:)]) {
        [_messageDelegate onTapAvatar:self.model.message.sender];
    }
}

- (void)onRetryMessage:(id)sender {
    if ([_messageDelegate respondsToSelector:@selector(messageCell:didClickRetryWithMessage:)]) {
        [_messageDelegate messageCell:self didClickRetryWithMessage:self.model.message];
    }
}

- (void)longGesturePress:(UIGestureRecognizer*)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] &&
        gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (_messageDelegate && [_messageDelegate respondsToSelector:@selector(onLongPressCell:inView:)]) {
            [_messageDelegate onLongPressCell:self.model.message inView:_bubbleView];

        }
    }
}

- (void)onTapBubbleView:(id)sender {
    if (_messageDelegate &&[_messageDelegate respondsToSelector:@selector(messageCell:didClickBubbleView:message:)]) {
        [_messageDelegate messageCell:self didClickBubbleView:_bubbleView message:self.model.message];
    }
}

- (void)onTapReaded:(id)sender {
    
    if ([self.messageDelegate respondsToSelector:@selector(messageCell:didClickReadedWithMessage:)]) {
        [self.messageDelegate messageCell:self didClickReadedWithMessage:self.model.message];
    }
}









#pragma mark - ———— getter ———— -

- (TimeStampLabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[TimeStampLabel alloc] init];
    }
    return _timeLabel;
}

- (UIButton *)headImageView {
    
    if (!_headImageView) {
        _headImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageView.frame = CGRectMake(0, 0, 40, 40);
        _headImageView.clipsToBounds = YES;
        _headImageView.backgroundColor = [UIColor redColor];
        [_headImageView addTarget:self action:@selector(onTapAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textColor = [UIColor colorWithHexString:@"5A5A5A"];
    }
    return _nameLabel;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    }
    return _indicator;
}

- (UIButton *)retryButton {
    
    if (!_retryButton) {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setFrame:CGRectMake(0, 0, 20, 20)];
        [_retryButton setImage:[UIImage y2w_imageNamed:@"消息单元格-重发"] forState:UIControlStateNormal];
//        [_retryButton setImage:[UIImage nim_imageInKit:@"icon_message_cell_error"] forState:UIControlStateHighlighted];
//        _retryButton.backgroundColor = [UIColor redColor];
        [_retryButton addTarget:self action:@selector(onRetryMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

- (UIButton *)readedButton {
    
    if (!_readedButton) {
        _readedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readedButton setTitle:@"已读" forState:UIControlStateNormal];
        [_readedButton setTitleColor:[UIColor y2w_mainColor] forState:UIControlStateNormal];
        [_readedButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_readedButton setFrame:CGRectMake(0, 0, 30, 20)];
        [_readedButton addTarget:self action:@selector(onTapReaded:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readedButton;
}


- (NSMutableDictionary *)bubbleViews {
    if (!_bubbleViews) {
        _bubbleViews = [NSMutableDictionary dictionary];
    }
    return _bubbleViews;
}

- (UIView<MessageBubbleInterface> *)bubbleView {
    UIView <MessageBubbleInterface> *bubbleView = self.bubbleViews[self.model.bubbleViewClassName];
    if (!bubbleView) {
        bubbleView = [NSClassFromString(self.model.bubbleViewClassName) create];
        if (bubbleView) self.bubbleViews[self.model.bubbleViewClassName] = bubbleView;
    }
    if (_bubbleView != bubbleView) {
        [_bubbleView removeFromSuperview];
        _bubbleView = bubbleView;
        [self.contentView addSubview:_bubbleView];
    }
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapBubbleView:)];
    [_bubbleView addGestureRecognizer:tapGesture];
    return _bubbleView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.tintColor = [UIColor colorWithHexString:@"#ffc950"];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.borderWidth = 0.5;
        _progressView.layer.borderColor = [UIColor colorWithHexString:@"@c8c8c8c"].CGColor;
    }
    return _progressView;
}

- (UILabel *)progressNumbLabel
{
    if (!_progressNumbLabel) {
        _progressNumbLabel = [[UILabel alloc]init];
        _progressNumbLabel.font = [UIFont systemFontOfSize:12];
        _progressNumbLabel.textColor = [UIColor colorWithHexString:@"353535"];
        _progressNumbLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }
    return _progressNumbLabel;
}

@end
