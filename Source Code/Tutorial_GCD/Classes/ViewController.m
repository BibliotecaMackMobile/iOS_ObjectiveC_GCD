//
//  ViewController.m
//  Tutorial_GCD
//
//  Created by Kaê Coutinho - BEPiD on 3/17/14.
//  Copyright (c) 2014 Kaê Coutinho. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()

-(void)iniciarInterface;

@end

@implementation ViewController

@synthesize outputTabuadaTextView;
@synthesize outputBlocoUnicoLabel;
@synthesize outputImagemImageView;
@synthesize activityIndicator;

#pragma mark - UIView

-(void)viewDidLoad
{
    [self iniciarInterface];
    [super viewDidLoad];
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

-(IBAction)tabuadaSincrona:(UIButton *)sender
{
    [outputTabuadaTextView setText:@"SÍNCRONO"];
    // Abertura de processo paralelo síncrono
    // A constante "DISPATCH_QUEUE_PRIORITY_DEFAULT" representa o valor "0" e significa que irá retornar a thread mais bem avaliada e ociosa naquele momento de sua chamada
    // O segundo parametro "0" significa a não adição de flags para tal função, apenas o padrão
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^
    {
        // Algoritmo de tabuada do 0 -> 10
        for(NSInteger numeroAtual = 0; numeroAtual <= 10; numeroAtual++)
            for(NSInteger iteracao = 0; iteracao <= 10; iteracao++)
                // Atualiza o UITextView com as informações atuais
                [outputTabuadaTextView setText:[NSString stringWithFormat:@"%@\n%ld x %ld = %ld",[outputTabuadaTextView text],(long)numeroAtual,(long)iteracao,(numeroAtual * iteracao)]];
    });
}

-(IBAction)tabuadaAssincrona:(UIButton *)sender
{
    [outputTabuadaTextView setText:@"ASSÍNCRONO"];
    // Abertura de processo paralelo assíncrono
    // A constante "DISPATCH_QUEUE_PRIORITY_DEFAULT" representa o valor "0" e significa que irá retornar a thread mais bem avaliada e ociosa naquele momento de sua chamada
    // O segundo parametro "0" significa a não adição de flags para tal função, apenas o padrão
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^
    {
        // Algoritmo de tabuada do 0 -> 10
        for(NSInteger numeroAtual = 0; numeroAtual <= 10; numeroAtual++)
            for(NSInteger iteracao = 0; iteracao <= 10; iteracao++)
                // Como a thread é assíncrona, perdemos o vincúlo com a interface gráfica, logo, é necessário recuperarmos nossa thread principal para fazer a atualização do UITextView
                // Note que quando a thread é síncrona, isso não é necessário
                // Abertura do processo paralelo assíncrono
                // A função dispatch_get_main_queue() retorna a thread principal da nossa aplicação
                dispatch_async(dispatch_get_main_queue(),^
                {
                    // Atualiza o UITextView com as informações atuais
                    [outputTabuadaTextView setText:[NSString stringWithFormat:@"%@\n%ld x %ld = %ld",[outputTabuadaTextView text],(long)numeroAtual,(long)iteracao,(numeroAtual * iteracao)]];
                });
    });
}

-(IBAction)executarBlocoUnico:(UIButton *)sender
{
    // Variável de controle do bloco único
    static BOOL executado = NO;
    // Variável token para garantir a execução única do bloco seguinte
    // Similar a um "fosforo", só tem uso uma única vez, depois de queimado se torna inútil
    static dispatch_once_t tokenUnico;
    if(executado)
        // Atualiza o UILabel com as informações atuais
        [outputBlocoUnicoLabel setText:@"Bloco já fora executado!"];
    dispatch_once(&tokenUnico,^
    {
        executado = YES;
        // Atualiza o UILabel com as informações atuais
        [outputBlocoUnicoLabel setText:@"Executado bloco único!"];
    });
}

-(IBAction)baixarImagem:(UIButton *)sender
{
    [activityIndicator startAnimating];
    // Abertura de processo paralelo assíncrono
    // A constante "DISPATCH_QUEUE_PRIORITY_DEFAULT" representa o valor "0" e significa que irá retornar a thread mais bem avaliada e ociosa naquele momento de sua chamada
    // O segundo parametro "0" significa a não adição de flags para tal função, apenas o padrão
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^
    {
        // Processo de download da imagem
        NSString * imagemCaminho = @"http://static2.wikia.nocookie.net/__cb20110204201432/bakuganrandomtalk/images/thumb/c/c8/TrollFace.png/768px-TrollFace.png";
        NSURL * imagemURL = [[NSURL alloc] initWithString:imagemCaminho];
        NSData * imagemData = [[NSData alloc] initWithContentsOfURL:imagemURL];
        UIImage * imagem = [[UIImage alloc] initWithData:imagemData];
        // Como a thread é assíncrona, perdemos o vincúlo com a interface gráfica, logo, é necessário recuperarmos nossa thread principal para fazer a atualização do UIImageView
        // Note que quando a thread é síncrona, isso não é necessário
        // Abertura do processo paralelo assíncrono
        // A função dispatch_get_main_queue() retorna a thread principal da nossa aplicação
        dispatch_async(dispatch_get_main_queue(),^
        {
            [activityIndicator stopAnimating];
            // Atualiza o UIImageView com a nova imagem
            [outputImagemImageView setImage:imagem];
        });
    });
}

-(IBAction)resetar:(UIButton *)sender
{
    [outputTabuadaTextView setText:nil];
    [outputBlocoUnicoLabel setText:nil];
    [outputImagemImageView setImage:nil];
}

#pragma mark - Métodos Auxiliares

-(void)iniciarInterface
{
    [outputTabuadaTextView setText:nil];
    [outputTabuadaTextView setUserInteractionEnabled:YES];
    [outputTabuadaTextView setScrollEnabled:YES];
    [outputTabuadaTextView setEditable:NO];
    [outputBlocoUnicoLabel setText:nil];
    [activityIndicator setHidesWhenStopped:YES];
}

@end
