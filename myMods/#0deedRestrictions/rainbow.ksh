   rainbow
      MatrixP                                                                                MatrixV                                                                                MatrixW                                                                                SAMPLER    +         LIGHTMAP_WORLD_EXTENTS                             
   TIMEPARAMS                                PARAMS                        FLOAT_PARAMS                            OCEAN_BLEND_PARAMS                                OCEAN_WORLD_EXTENTS                                xxx.vsr  uniform mat4 MatrixP;
uniform mat4 MatrixV;
uniform mat4 MatrixW;
uniform vec4 TIMEPARAMS;
uniform vec3 FLOAT_PARAMS;

attribute vec4 POS2D_UV;                  // x, y, u + samplerIndex * 2, v

varying vec3 PS_TEXCOORD;
varying vec3 PS_POS;

void main()
{
    vec3 POSITION = vec3( POS2D_UV.x, POS2D_UV.y, 0 );
    float samplerIndex = floor( POS2D_UV.z / 2.0 );
    vec3 TEXCOORD0 = vec3( POS2D_UV.z - 2.0 * samplerIndex, POS2D_UV.w, samplerIndex );

	vec4 world_pos = MatrixW * vec4( POSITION, 1.0 );
	gl_Position = MatrixP * MatrixV * world_pos;

	PS_TEXCOORD = TEXCOORD0;
	PS_POS = world_pos.xyz;
}    xxx.ps�  #if defined( GL_ES )
precision mediump float;
#endif

uniform mat4 MatrixW;

uniform sampler2D SAMPLER[5];


#ifndef LIGHTING_H
#define LIGHTING_H

// Lighting
varying vec3 PS_POS;

// xy = min, zw = max
uniform vec4 LIGHTMAP_WORLD_EXTENTS;

#define LIGHTMAP_TEXTURE SAMPLER[3]

#ifndef LIGHTMAP_TEXTURE
	#error If you use lighting, you must #define the sampler that the lightmap belongs to
#endif

vec3 CalculateLightingContribution()
{
	vec2 uv = ( PS_POS.xz - LIGHTMAP_WORLD_EXTENTS.xy ) * LIGHTMAP_WORLD_EXTENTS.zw;

	return texture2D( LIGHTMAP_TEXTURE, uv.xy ).rgb;
}

vec3 CalculateLightingContribution( vec3 normal )
{
	return vec3( 1, 1, 1 );
}

#endif //LIGHTING.h


varying vec3 PS_TEXCOORD;

uniform vec4 TIMEPARAMS;

uniform vec4 TINT_ADD;
uniform vec4 TINT_MULT;
uniform vec2 PARAMS;
uniform vec3 FLOAT_PARAMS;
uniform vec4 HAUNTPARAMS;
uniform vec4 HAUNTPARAMS2;
uniform vec4 OCEAN_BLEND_PARAMS;
uniform vec3 CAMERARIGHT;

#define ALPHA_TEST PARAMS.x
#define LIGHT_OVERRIDE PARAMS.y

uniform vec4 OCEAN_WORLD_EXTENTS;
#define OCEAN_SAMPLER SAMPLER[4]

void main()
{
    vec4 colour;

    if( PS_TEXCOORD.z < 0.5 )
    {
        colour.rgba = texture2D( SAMPLER[0], PS_TEXCOORD.xy );
    }
    else
    {
        colour.rgba = texture2D( SAMPLER[1], PS_TEXCOORD.xy );
    }

    if(FLOAT_PARAMS.y > 0.0)
    {
    	if(PS_POS.y < FLOAT_PARAMS.x)
    	{
    		discard;
    	}
    }

    if( colour.a >= ALPHA_TEST )
    {

        gl_FragColor.rgba = colour.rgba;
        //gl_FragColor.rgba *= TINT_MULT.rgba;
        //gl_FragColor.rgb += vec3( TINT_ADD.rgb * colour.a );
		gl_FragColor.rgb = (0.8 + sin(TIMEPARAMS.x + PS_POS.xyx + vec3(0.0, 2.0, 4.0))) * colour.a;
		gl_FragColor.rgba *= 0.7;

		vec2 world_uv = ( PS_POS.xz - OCEAN_WORLD_EXTENTS.xy ) * OCEAN_WORLD_EXTENTS.zw;
		vec3 world_tint = texture2D( OCEAN_SAMPLER, world_uv ).rgb;
		gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb * world_tint.rgb, OCEAN_BLEND_PARAMS.x);

        vec3 light = CalculateLightingContribution();

        gl_FragColor.rgb *= max( light.rgb, vec3( LIGHT_OVERRIDE, LIGHT_OVERRIDE, LIGHT_OVERRIDE ) );

    }
    else
    {
        discard;
    }
}                                   	   