//
//  DownloadedItemCell.h
//  TestTask
//
//  Created by Alexandr on 15.04.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieEntity;

@interface DownloadedItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (void)configureCellWithMovie:(MovieEntity*)movie;

@end
