//
//  FollowModel.m
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "FollowModel.h"

@implementation FollowModel

-(NSMutableAttributedString *)iocnAttributedString{

    if (_iocnAttributedString == nil) {
        
        _iocnAttributedString = [NSMutableAttributedString new];
        
        if (_sub>0) {
            
            NSTextAttachment *textAtttachment = [NSTextAttachment new];
            textAtttachment.image = [UIImage imageNamed:@"shop_jian"];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAtttachment];
            [_iocnAttributedString appendAttributedString:attachmentString];
        }

        if (_give>0) {
            
            [_iocnAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            NSTextAttachment *textAtttachment = [NSTextAttachment new];
            textAtttachment.image = [UIImage imageNamed:@"shop_zeng"];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAtttachment];
            [_iocnAttributedString appendAttributedString:attachmentString];
        }
        
        
    }
    return _iocnAttributedString;
}

@end
