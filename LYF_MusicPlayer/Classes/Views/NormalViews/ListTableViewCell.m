//
//  ListTableViewCell.m
//  LYF_MusicPlayer
//
//  Created by 罗元丰 on 16/1/13.
//  Copyright © 2016年 罗元丰. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@end

@implementation ListTableViewCell

-(void)setModel:(ListModel *)model
{
    _model = model;
    //为控件赋值
    //歌名 作者 图片picUrl
    self.nameLabel.text = model.name;
    self.singerLabel.text = model.singer;
    [self.imgView sd_setImageWithURL: [NSURL URLWithString: model.picUrl] placeholderImage: [UIImage imageNamed: @"picholder@2x"]];
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
