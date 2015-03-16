//
//  UIImageView+IP.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/15/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "UIImage+WebP.h"
#import "UIImageView+IP.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (IP)

- (void)setImageFromWebPURL:(NSURL *)url completion:(void (^)(UIImage *img))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithWebPData:data];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completion(img);
        });
    });

}

- (void)ip_setImageWithURL:(NSURL *)url {

    NSString *urlString = url.absoluteString;
    if ([urlString hasSuffix:@".webp"]) {

        [self setImageFromWebPURL:url completion:^(UIImage *img) {
            self.image = img;
        }];
        return;
    }

    [self setImageWithURL:url];
}


@end
