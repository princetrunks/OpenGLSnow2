// Fragment Shader

static const char* FRAGMENTSHADER = FILENAMETOSTRING
(
  uniform sampler2D       u_Texture;
 
 void main(void)
{
    // Texture
    highp vec4 texture = texture2D(u_Texture, gl_PointCoord);
    gl_FragColor = texture;
}
 
 );