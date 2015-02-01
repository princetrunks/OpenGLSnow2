//
//  ShaderCompiler.m
//  OpenGLSnow
//
//  Created by chuck on 1/31/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

#import "ShaderCompiler.h"

@implementation ShaderCompiler

- (GLuint)CompileProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource
{
    // build the shaders using the BuildShader helper method
    GLuint vertexShader = [self BuildShader:vertexShaderSource with:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self BuildShader:fragmentShaderSource with:GL_FRAGMENT_SHADER];
    
    //creates program
    GLuint programHandle = glCreateProgram();
    
    // Attach the vertex and fragment shaders
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    
    // link program
    glLinkProgram(programHandle);
    
    //error check
    GLint didLinkSucceed;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &didLinkSucceed);
    if (didLinkSucceed == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0,&messages[0]);
        NSString *errorString = [NSString stringWithUTF8String:messages];
        NSLog(@"Program Link Error:/n %@", errorString);
        exit(1);
    }
    
    // delete the shaders
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return programHandle;
}



- (GLuint)BuildShader:(const char*)source with:(GLenum)shaderType
{
    // Create the shader object
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // Load the shader source
    glShaderSource(shaderHandle, 1, &source, 0);
    
    // Compile the shader
    glCompileShader(shaderHandle);
    
    // compile error check
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE)
    {
        NSLog(@"GLSL Shader Error");
        GLchar messages[1024];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSLog(@"%s", messages);
        exit(1); // also abort program early if an error is caught
    }
    
    return shaderHandle;
}


@end
