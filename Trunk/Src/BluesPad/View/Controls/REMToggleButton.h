//
//  REMToggleButton.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 8/19/13.
//
//

#import <UIKit/UIKit.h>

@interface REMToggleButton : UIButton

@property (nonatomic, getter=isOn) BOOL on;

- (BOOL)toggle;

@end
