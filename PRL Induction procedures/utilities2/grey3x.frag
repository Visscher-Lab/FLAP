#extension GL_ARB_texture_rectangle : enable

uniform sampler2D Image;

void main()
{
    /* Retrieve RGBA HDR input color value. */
    vec2 readpos_red = gl_TexCoord[0].xy;
    readpos_red.x = readpos_red.x*3.0+0.0;
    
    vec2 readpos_green = gl_TexCoord[0].xy;
    readpos_green.x = readpos_green.x*3.0+1.0; 
    
    vec2 readpos_blue = gl_TexCoord[0].xy;
    readpos_blue.x = readpos_blue.x*3.0+2.0;
    
    if (gl_TexCoord[0].x > 0.0)
    {
        gl_FragColor.r = texture2D(Image, vec2(floor(gl_FragCoord.x*3.0)/1920.0,gl_FragCoord.y/1080.0)).r;
        gl_FragColor.g = texture2D(Image, vec2(floor(gl_FragCoord.x*3.0+1.0)/1920.0,gl_FragCoord.y/1080.0)).r;
        gl_FragColor.b = texture2D(Image, vec2(floor(gl_FragCoord.x*3.0+2.0)/1920.0,gl_FragCoord.y/1080.0)).r;
        gl_FragColor.a = 1.0;
    }
    else
    {
    gl_FragColor.r = 0.0;
    gl_FragColor.g = 0.0;
    gl_FragColor.b = 0.0;
    gl_FragColor.a = 1.0;
    }
}
