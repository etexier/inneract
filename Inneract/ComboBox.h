//
//  ComboBox.h
//  Inneract
//
//  Created by Syed Naqvi on 3/9/15.
//  Copyright (c) 2015 Syed Naqvi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComboBox : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView* pickerView;
    IBOutlet UITextField* textField;
    NSMutableArray *dataArray;
}

-(void) setComboData:(NSMutableArray*) data; //set the picker view items
@property (strong, nonatomic) NSString* selectedText; //the UITextField text

@end
