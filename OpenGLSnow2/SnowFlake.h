//
//  SnowObject.h
//  OpenGLSnow
//
//  Created by chuck on 1/30/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Common.h"
#import "ShaderCompiler.h"

@interface SnowFlake : NSObject

// Emitter Data
@property (assign) SnowParticleEmitter emitter;

// Emitter Lifespan & timer
@property (nonatomic,assign) NSTimeInterval lifeSpan;

//@property   NSTimeInterval lifeSpan;
//@property (readwrite) NSTimeInterval timer;


// Program Handle
@property (readwrite) GLuint    program;

// Shader Attribute Handles
@property (readwrite) GLint     a_Position;
@property (readwrite) GLint     a_pVelocityOffset;
@property (readwrite) GLint     a_pSizeOffset;

// Shader Uniform Handles
@property (readwrite) GLuint    u_ProjectionMatrix;
@property (readwrite) GLint     u_Gravity;
@property (readwrite) GLint     u_Time;
@property (readwrite) GLint     u_Texture;
@property (readwrite) GLint     u_Position;

- (id)initWithTexture:(NSString *)fileName at:(GLKVector2)position;
- (void)renderWithProjection:(GLKMatrix4)projectionMatrix;
- (BOOL)updateFlakeRender:(NSTimeInterval)dt;

@end
