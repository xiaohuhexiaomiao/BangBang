//
//  StampView.m
//  FindWorkerApp
//
//  Created by cxz on 2017/6/29.
//  Copyright © 2017年 SimonWest. All rights reserved.
//

#import "StampView.h"
#import "CXZ.h"

@interface StampListModel : NSObject

@property(nonatomic ,copy)NSString  *reason;

@property(nonatomic ,copy)NSString  *contract_name;

@property(nonatomic ,copy)NSString  *num;

@property(nonatomic ,copy)NSString  *remarks;

@property(nonatomic ,assign)NSInteger  company_type;

@property(nonatomic ,copy)NSString *name_company;

@property(nonatomic ,assign)NSInteger seal_type;

@end

@implementation StampListModel


@end



@interface StampView()<UITextFieldDelegate>

@property(nonatomic ,strong)UIButton *selectedStampButton;

@property(nonatomic ,strong)UIButton *deleteButton;

@property(nonatomic ,strong)UIView *line;

@end
@implementation StampView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSString *reason = @"盖章事由：";
        CGSize reasonSize = [reason sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *reasonLabel = [self customUILabelWithFrame:CGRectMake(8, 0, reasonSize.width, 25) title:reason];
        [self addSubview:reasonLabel];
        
        _reasonTxt = [self customTextFieldWithFrame:CGRectMake(reasonLabel.right, reasonLabel.top, SCREEN_WIDTH-reasonLabel.right-20, reasonLabel.height)];
        [self addSubview:_reasonTxt];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(SCREEN_WIDTH-20, 0, 20, 20);
        [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        NSString *file = @"资料名称：";
        CGSize fileSize = [file sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *fileLabel = [self customUILabelWithFrame:CGRectMake(reasonLabel.left, reasonLabel.bottom, fileSize.width, reasonLabel.height) title:file];
        [self addSubview:fileLabel];
        
        _fileNameTxt = [self customTextFieldWithFrame:CGRectMake(fileLabel.right, fileLabel.top, SCREEN_WIDTH-fileLabel.width-8, fileLabel.height)];
        [self addSubview:_fileNameTxt];
        
        NSString *num = @"数量：";
        CGSize numSize = [num sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *numLabel = [self customUILabelWithFrame:CGRectMake(fileLabel.left, fileLabel.bottom, numSize.width, fileLabel.height) title:num];
        [self addSubview:numLabel];
        
        _numTxt = [self customTextFieldWithFrame:CGRectMake(numLabel.right, numLabel.top,SCREEN_WIDTH-numLabel.right-8, numLabel.height)];
        [self addSubview:_numTxt];
        
        
        NSString *stamp = @"印章类别：";
        CGSize stampSize = [stamp sizeWithFont:[UIFont systemFontOfSize:12] width:SCREEN_WIDTH];
        UILabel *stampLabel = [self customUILabelWithFrame:CGRectMake(numLabel.left, numLabel.bottom, stampSize.width, numLabel.height) title:stamp];
        [self addSubview:stampLabel];
        
        _selectedStampButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedStampButton.frame = CGRectMake(stampLabel.right, stampLabel.top, 60, stampLabel.height);
        _selectedStampButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_selectedStampButton setTitleColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1.00] forState:UIControlStateNormal];
        [_selectedStampButton addTarget:self action:@selector(clickSelectedStampType) forControlEvents:UIControlEventTouchUpInside];
        _selectedStampButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self addSubview:_selectedStampButton];
        
        
        UILabel *companyLabel = [self customUILabelWithFrame:CGRectMake(_selectedStampButton.right, _selectedStampButton.top, numLabel.width, numLabel.height) title:@"公司："];
        [self addSubview:companyLabel];
        
        _selectedCompanyButton = [self customTextFieldWithFrame:CGRectMake(companyLabel.right, companyLabel.top, SCREEN_WIDTH-companyLabel.right-8, companyLabel.height)];
        [self addSubview:_selectedCompanyButton];
        
        UILabel *markLabel = [self customUILabelWithFrame:CGRectMake(8, companyLabel.bottom, numLabel.width, numLabel.height) title:@"备注："];
        [self addSubview:markLabel];

        _remarkTxt = [self customTextFieldWithFrame:CGRectMake(markLabel.right, markLabel.top, SCREEN_WIDTH-markLabel.right-8, 24)];
        [self addSubview:_remarkTxt];
        
        
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(8, _remarkTxt.bottom, SCREEN_WIDTH-16, 1)];
        _line.backgroundColor = UIColorFromRGB(224, 223, 226);
        [self addSubview:_line];
        
    }
    return self;
}


-(void)showCopyStampViewData:(NSDictionary*)dict
{
    StampListModel *stamp = [StampListModel objectWithKeyValues:dict];
    self.reasonTxt.text = stamp.reason;
    self.fileNameTxt.text = stamp.contract_name;
    self.numTxt.text = stamp.num;
    self.remarkTxt.text = stamp.remarks;
    if (stamp.company_type) {
        if (stamp.company_type ==1) {
            self.selectedCompanyButton.text = @"杭州旭邦装饰有限公司";
            
        }else{
            self.selectedCompanyButton.text = @"杭州大旭邦装饰有限公司";
            
        }
    }
    if (![NSString isBlankString:stamp.name_company]) {
        self.selectedCompanyButton.text = stamp.name_company;
    }
    switch (stamp.seal_type) {
        case 1:[self.selectedStampButton setTitle:@"公章" forState:UIControlStateNormal];
            break;
        case 2:[self.selectedStampButton setTitle:@"法人章" forState:UIControlStateNormal];break;
        case 3:[self.selectedStampButton setTitle:@"财务章" forState:UIControlStateNormal];break;
        case 4:[self.selectedStampButton setTitle:@"发票章" forState:UIControlStateNormal];break;
        case 5:[self.selectedStampButton setTitle:@"合同章" forState:UIControlStateNormal];
        default:
            break;
    }

}

-(void)clickSelectedStampType
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"公章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectedStampButton setTitle:@"公章" forState:UIControlStateNormal];
        self.stampType = @"1";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"法人章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectedStampButton setTitle:@"法人章" forState:UIControlStateNormal];
        self.stampType = @"2";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"财务章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectedStampButton setTitle:@"财务章" forState:UIControlStateNormal];
        self.stampType = @"3";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"发票章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectedStampButton setTitle:@"发票章" forState:UIControlStateNormal];
        self.stampType = @"4";
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"合同章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectedStampButton setTitle:@"合同章" forState:UIControlStateNormal];
        self.stampType = @"5";
    }]];
    [self.viewController presentViewController:alertVC animated:YES completion:NULL];
    
}




-(void)clickDeleteButton:(UIButton*)button
{
    [self.delegate deleteStampView:self.tag];
}

-(UITextField*)customTextFieldWithFrame:(CGRect)frame
{
    UITextField *textfield = [[UITextField alloc]initWithFrame:frame];
    textfield.delegate = self;
    textfield.font = [UIFont systemFontOfSize:12];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.textColor = FORMTITLECOLOR;
    return textfield;
}

-(UILabel*)customUILabelWithFrame:(CGRect)frame title:(NSString*)title
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = FORMLABELTITLECOLOR;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    return label;
}

#pragma mark UITextfield Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}





@end
