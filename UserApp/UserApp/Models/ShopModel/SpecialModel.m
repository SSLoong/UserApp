//
//  SpecialModel.m
//  UserApp
//
//  Created by prefect on 16/4/15.
//  Copyright © 2016年 Perfect. All rights reserved.
//

#import "SpecialModel.h"
#import "NSTextAttachment+Util.h"

@implementation SpecialModel


-(NSMutableAttributedString *)iconAttributedString{

    if(_iconAttributedString == nil){
    
        _iconAttributedString = [NSMutableAttributedString new];
        
        if (_mk_strategy == 3) {
            
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:@"shop_zeng"];
            [textAttachment setY:-2];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            _iconAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [_iconAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }else if(_mk_strategy == 2){
        
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            textAttachment.image = [UIImage imageNamed:@"shop_jian"];
            [textAttachment setY:-2];
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            _iconAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
            [_iconAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];

        }
        
        if (self.strategy.length > 0) {
            [_iconAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.strategy]];
        }
    
    }
    return _iconAttributedString;
}

@end
