//
//  ViewController.m
//  OpenGLSnow
//
//  Created by chuck on 1/30/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

#import "ViewController.h"
#import "SnowFlake.h"

@interface ViewController ()

//used to store and remove snow emitter objects
@property (readwrite) NSMutableArray* emitters;

@end


@implementation ViewController{
    
    GLKVector2 spawnPosition;
    NSTimeInterval respawnTimer;
    NSTimeInterval currentEmitterLifeSpan;
    BOOL canRespawn;
    NSMutableArray* _deadEmitters;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupContext];
    
    [self setupScene];
    
}

- (void)setupContext{
    
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // set's up the view.. in this case, an instance of GLKView
    GLKView* view = (GLKView*) self.view;
    view.context = context;
    
    // Set up Emitters
    self.emitters = [NSMutableArray array];
    
}

- (void)setupScene{
    
    //programmically set viewcontroller's FPS since it defaults at 30
    self.preferredFramesPerSecond = 60; //2x faster than 'cinematic'
    
    NSTimeInterval initialLifeSpan = PARTICLE_LIFE_SPAN/3;
    
    respawnTimer = 0.0f;
    
    //create Emitter container array
    _deadEmitters = [NSMutableArray array];
    
    //start snowfall at point (0,0.6) at start
    [self createSnowFallAtLocation:GLKVector2Make(0,0.6) withLifeSpan:&initialLifeSpan];
    
}

//Snowfall constructors
-(void)createSnowFallAtLocation:(GLKVector2)Location {
    
    SnowFlake* emitter = [[SnowFlake alloc] initWithTexture:@"snow_texture.png" at:GLKVector2Make(Location.x, Location.y)];
    [self.emitters addObject:emitter];
    
}

-(void)createSnowFallAtLocation:(GLKVector2)Location withLifeSpan:(NSTimeInterval *)lifeSpan{
    
    SnowFlake* emitter = [[SnowFlake alloc] initWithTexture:@"snow_texture.png" at:GLKVector2Make(Location.x, Location.y)];
    
    emitter.lifeSpan = *(lifeSpan);
    
    [self.emitters addObject:emitter];
    
}


//GLKView

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //BG color; dark gray
    glClearColor(0.3, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Set the blending 
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Creates the Projection Matrix
    float aspectRatio = view.frame.size.width / view.frame.size.height;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    // Render Emitters
    if([self.emitters count] != 0)
    {
        for(SnowFlake* emitter in self.emitters)
        {
            [emitter renderWithProjection:projectionMatrix];
        }
    }
}


- (void)update
{
    
    respawnTimer += self.timeSinceLastUpdate;
    
    // Update Emitters
    if([self.emitters count] != 0)
    {
        
        
        for(SnowFlake* emitter in self.emitters)
        {
            //currentEmitter = emitter;
            currentEmitterLifeSpan = emitter.lifeSpan;
            
            BOOL isLive = [emitter updateFlakeRender: self.timeSinceLastUpdate];
            
            //checks if current
            if(!isLive){
                [_deadEmitters addObject:emitter];
            }
        }
        
        //spawn a new emitter?
        if (respawnTimer >= currentEmitterLifeSpan/4){
            [self createSnowFallAtLocation:GLKVector2Make(0,4)];
            respawnTimer = 0.0f; // reset respawn timer
        }
        
        //remove expired emitter(s)
        for(SnowFlake* emitter in _deadEmitters)
            [self.emitters removeObject:emitter];
        
        //NSLog(@"emitters array count: %d",[self.emitters count]);
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

