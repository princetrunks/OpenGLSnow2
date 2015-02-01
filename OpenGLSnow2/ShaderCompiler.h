//
//  ShaderCompiler.h
//  OpenGLSnow
//
//  Created by chuck on 1/31/15.
//  Copyright (c) 2015 Chuck Gaffney. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ShaderCompiler : NSObject

- (GLuint)CompileProgram:(const char*)vertexShaderSource with:(const char*)fragmentShaderSource;

@end
