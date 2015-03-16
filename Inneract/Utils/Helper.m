//
// Created by Emmanuel Texier on 3/7/15.
// Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "Helper.h"
#import "UIImage+WebP.h"


@implementation Helper


static NSDateFormatter *_dateFormatter = nil;

+(NSDateFormatter *)postedDateFormatterInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM/dd/YYYY"];
        [_dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return _dateFormatter;
}
+ (NSString *)postedDate:(NSDate *)date {
    NSString *dateString = [self.postedDateFormatterInstance stringFromDate:date];
    return dateString;
}


+ (NSString *) embeddedVimeoIFrameForId:(NSString *) id {
    static NSString *const kTemplate = @"<iframe src=\"https://player.vimeo.com/video/%@?badge=0&byline=0&portrait=0&title=0&color=ffb302\" width=\"320\" height=\"200\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>";
    return [NSString stringWithFormat:kTemplate, id];
}


+ (void)embedVimeoVideoId:(NSString *)videoId inView:(UIWebView *) view {
    NSString *templateString = @"<html>\n"
            "\n"
            "<style type=\"text/css\">\n"
            "body {\n"
            "  background-color: transparent;\"];\n"
            "  color: white;\"];\n"
            "}\n"
            "</style>\n"
            "</head>\n"
            "<body style=\"margin:0\">\n"
            "\n%@\n"
            "</body>\n"
            "\n"
            "</html>";
    NSString *html = [NSString stringWithFormat:templateString, [Helper embeddedVimeoIFrameForId:videoId]];
    [view loadHTMLString:html baseURL:nil];

}

+(void) setImageFromWebPURL:(NSString *) urlString completion:(void (^)(UIImage * img)) completion {
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithWebPData:data];
        dispatch_async( dispatch_get_main_queue(), ^(void){
            completion(img);
        });
    });

}
@end