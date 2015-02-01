//
//  SnowObject.m
//  OpenGLSnow
//
//  Created by chuck on 1/30/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

#import "SnowFlake.h"
#import "ShaderCompiler.h"

// Shader Import
#include "Vertex.glsl"
#include "Fragment.glsl"


@implementation SnowFlake{
    
    GLuint      _particleBuffer;
    GLKVector2  _gravity;
    float       _time;
    
}

- (id)initWithTexture:(NSString *)fileName at:(GLKVector2)position;
{
    if(self = [super init])
    {
        _particleBuffer = 0;
        self.lifeSpan = PARTICLE_LIFE_SPAN;
        _time = 0.0f;
        
         _gravity = GLKVector2Make(0.0f, 0.0f);
        
        // Load Shader
        [self loadShaderData];
        
        // Load Texture
        [self loadSnowTexture:fileName];
        
        // Load Particle System
        [self loadParticleSystem:position];
        
    }
    return self;
}

//random number generator
- (float)randomFloatBetween:(float)min and:(float)max
{
    float range = max - min;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * range) + min;
}


- (void)loadShaderData{
    
    
    // Program
    ShaderCompiler* shaderCompiler = [[ShaderCompiler alloc] init];
    self.program = [shaderCompiler CompileProgram:VERTEXSHADER with:FRAGMENTSHADER];
    
    // Attributes
    self.a_Position = glGetAttribLocation(self.program, "a_Position");               //GL_Point position
    self.a_pVelocityOffset = glGetAttribLocation(self.program, "a_pVelocityOffset"); //variant velocity
    self.a_pSizeOffset = glGetAttribLocation(self.program, "a_pSizeOffset");         //variant size
    
    // Uniforms
    self.u_ProjectionMatrix = glGetUniformLocation(self.program, "u_ProjectionMatrix");
    self.u_Gravity = glGetUniformLocation(self.program, "u_Gravity");
    self.u_Time = glGetUniformLocation(self.program, "u_Time");
    self.u_Texture = glGetUniformLocation(self.program, "u_Texture");
    self.u_Position = glGetUniformLocation(self.program, "u_Position");
    
    glUseProgram(self.program);


}


- (void)loadSnowTexture:(NSString *)fileName
{
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],
                             GLKTextureLoaderOriginBottomLeft,
                             nil];
    
    NSError* error;
    
    //NSLog(@"GL Error = %u", glGetError());
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:&error];
    if(texture == nil)
    {
        NSLog(@"Error loading texture: %@", [error localizedDescription]);
        
        exit(1);
    }
    
    //links the texture to the gpu buffers
    glBindTexture(GL_TEXTURE_2D, texture.name);
    
    
}


- (void)loadParticleSystem:(GLKVector2)position
{
    SnowParticleEmitter newEmitter = {0.0f};
    
    // Offset limits
    float oVelocity = 1.50f;    // Speed
    float oSize = 8.00f;        // Pixels
    
    // Load Particles
    for(int i=0; i<NUM_SNOWFLAKES; i++)
    {
        //randomize the particle positions
        newEmitter.eParticles[i].Position[0] = [self randomFloatBetween:-2.00f and:2.00f]; //x
        newEmitter.eParticles[i].Position[1] = [self randomFloatBetween:-2.00f and:2.00f]; //y
        
        //random offsets within their range
        newEmitter.eParticles[i].pVelocityOffset = [self randomFloatBetween:1.0 and:oVelocity];
        newEmitter.eParticles[i].pSizeOffset = [self randomFloatBetween:-oSize and:oSize];
       
    }
    
    
    // Load Properties
    newEmitter.ePosition = position;                                // Source position
    newEmitter.eVelocity = 3.00f;                                   // Snowflake velocity
   
    
    //Gravity vars
    float drag = 10.00f;                                           // air resistance
    _gravity = GLKVector2Make(0.00f, -9.81*(1.0f/drag));           // earth's gravity
    
    // Set/assign Emmiter
    self.emitter = newEmitter;
    
    //Sets the VBO
    glGenBuffers(1, &_particleBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(self.emitter.eParticles), self.emitter.eParticles, GL_STATIC_DRAW);
}

- (void)renderWithProjection:(GLKMatrix4)projectionMatrix
{
    // Switches the Buffers
    glBindBuffer(GL_ARRAY_BUFFER, _particleBuffer);
    
    // Uniforms
    glUniformMatrix4fv(self.u_ProjectionMatrix, 1, 0, projectionMatrix.m);
    glUniform2f(self.u_Gravity, _gravity.x, _gravity.y);
    glUniform1f(self.u_Time, _time);
    
    glUniform2f(self.u_Position, self.emitter.ePosition.x, self.emitter.ePosition.y);
    glUniform1i(self.u_Texture, 0);
    
    // Attributes
    glEnableVertexAttribArray(self.a_Position);              //SnowFlake Particle position
    glEnableVertexAttribArray(self.a_pVelocityOffset);       //SnowFlake Particle Velocity variant
    glEnableVertexAttribArray(self.a_pSizeOffset);           //SnowFlack Particle Size variant
    
    //Particle Struct Pointers
    glVertexAttribPointer(self.a_Position, 2, GL_FLOAT, GL_FALSE, sizeof(Particles), (void*)(offsetof(Particles, Position)));
    glVertexAttribPointer(self.a_pVelocityOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particles), (void*)(offsetof(Particles, pVelocityOffset)));
    glVertexAttribPointer(self.a_pSizeOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Particles), (void*)(offsetof(Particles, pSizeOffset)));
    

    // Draw Snow Flakes
    glDrawArrays(GL_POINTS, 0, NUM_SNOWFLAKES);
    
    //Disable Attributes
    glDisableVertexAttribArray(self.a_Position);
    glDisableVertexAttribArray(self.a_pVelocityOffset);
    glDisableVertexAttribArray(self.a_pSizeOffset);
    
    //glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (BOOL)updateFlakeRender:(NSTimeInterval)dt
{
    _time += dt;
    
     /*
      NSLog(@"Lifespan: %f",self.lifeSpan);
     NSLog(@"_time: %f",_time);
      */
    
    //is emitter expired?
    if(_time < self.lifeSpan)
        return YES;
    else
        return NO;
    
   

}






@end
