// Vertex Shader

static const char* VERTEXSHADER = FILENAMETOSTRING
(
 
 // Attributes
 attribute vec2      a_Position;
 attribute float     a_pVelocityOffset;
 attribute float     a_pSizeOffset;
 
 // Uniforms
 uniform mat4        u_ProjectionMatrix;
 uniform vec2        u_Gravity;
 uniform float       u_Time;
 uniform vec2        u_Position;
 
 void main(void)
{
    float x = 0.0;
    float y = 0.0;
    
    float xCurve = 0.0;
    
    float timerDecay = 5.0;
    
    // Size default; could turn into an attribute
    float s = 15.0;
    
    //timer
    float time =  u_Time / timerDecay;
    
    //Particle Gravity
    x = u_Gravity.x * time;
    
    y = u_Gravity.y * time * a_pVelocityOffset;
    
    //sine curve
    xCurve = sin(timerDecay * a_pVelocityOffset *y)/timerDecay;
    
    //Randomize y velocity with velocity attribute
    y = y * a_pVelocityOffset;
    
    vec2 position = vec2(xCurve ,y) + (u_Position);
    gl_Position = u_ProjectionMatrix * vec4(a_Position.x + position.x, a_Position.y + position.y, 0.0, 1.0);
    gl_PointSize = max(0.0, (s + a_pSizeOffset));
    
}
 
 );