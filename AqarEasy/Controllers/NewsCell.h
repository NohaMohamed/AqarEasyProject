//
//  NewsCell.h
//  AqarEasy
//
//  Created by Assem Imam on 12/7/16.
//  Copyright © 2016 Eng.Eman.Rezk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsItemTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;

@end
