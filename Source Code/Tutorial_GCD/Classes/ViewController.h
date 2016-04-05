//
//  ViewController.h
//  Tutorial_GCD
//
//  Created by Kaê Coutinho - BEPiD on 3/17/14.
//  Copyright (c) 2014 Kaê Coutinho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet UITextView * outputTabuadaTextView;
@property (nonatomic,weak) IBOutlet UILabel * outputBlocoUnicoLabel;
@property (nonatomic,weak) IBOutlet UIImageView * outputImagemImageView;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView * activityIndicator;

-(IBAction)tabuadaSincrona:(UIButton *)sender;
-(IBAction)tabuadaAssincrona:(UIButton *)sender;
-(IBAction)executarBlocoUnico:(UIButton *)sender;
-(IBAction)baixarImagem:(UIButton *)sender;
-(IBAction)resetar:(UIButton *)sender;

@end
