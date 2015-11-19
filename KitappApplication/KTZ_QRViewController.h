//
//  KTZ_QRViewController.h
//  KitappApplication
//
//  Created by Bakytzhan Baizhikenov on 11/19/15.
//  Copyright © 2015 Olga Khvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface KTZ_QRViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *bbitemStart;

- (IBAction)startStopReading:(id)sender;

@end
