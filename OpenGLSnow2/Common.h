//
//  Common.h
//  OpenGLSnow
//
//  Created by chuck on 1/31/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

// Shared structs and macros

//Global Snow Constants
#define NUM_SNOWFLAKES      235
#define PARTICLE_LIFE_SPAN  64.0

//compacts shader files to an easy-to-use char string object
#define FILENAMETOSTRING(A) #A

typedef struct Particles
{
    GLfloat     Position[2];                  //Particle's starting position [x,y]
    float       pVelocityOffset;              //makes Velocity
    float       pSizeOffset;                  //makes GL_Point size more random
}
Particles;

typedef struct Emitter
{
    Particles   eParticles[NUM_SNOWFLAKES];
    GLKVector2  ePosition;                    //Emitter's main Position
    float       eVelocity;                    //Emitter's own Velocity
}
SnowParticleEmitter;
