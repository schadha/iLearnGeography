//
//  SectionCell.h
//  iLearnGeography
//
//  Created by Sanchit Chadha on 12/8/13.
//  Copyright (c) 2013 Sanchit Chadha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCell : UITableViewCell

// Custom label for cell in MenuViewController TableView
// If the cell is for a quiz, the numerator/denominator labels are shown.
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *numeratorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *sectionImage;
@property (strong, nonatomic) IBOutlet UILabel *denominatorLabel;

@end
