varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 resolution;

void main()
{
    float _a = texture2D( gm_BaseTexture, v_vTexcoord + resolution).a
              + texture2D( gm_BaseTexture, v_vTexcoord - resolution).a
              + texture2D( gm_BaseTexture, v_vTexcoord + vec2(resolution.x,-resolution.y)).a
              + texture2D( gm_BaseTexture, v_vTexcoord + vec2(-resolution.x,resolution.y)).a;
    
    vec4 _t = texture2D( gm_BaseTexture, v_vTexcoord );

    gl_FragColor = v_vColour * mix(_t,vec4(1.0,1.0,1.0,1.0),float((_t.a == 0.0) && (_a > 0.0)));
}
