//
//  TPKeyboardAvoidingScrollView.h
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2013 A Tasty Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@protocol ResignPopUp;

@interface TPKeyboardAvoidingScrollView : UIScrollView <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic,weak)id<ResignPopUp> PopUpDelegate;
- (void)contentSizeToFit;
- (BOOL)focusNextTextField;
- (void)scrollToActiveTextField;
@end


@protocol ResignPopUp <NSObject>

-(void)ResignHelpPopUp;

@end