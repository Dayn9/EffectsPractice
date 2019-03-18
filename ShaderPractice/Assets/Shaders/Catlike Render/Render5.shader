Shader "Unlit/Render5"
{
    Properties
    {
		_MainTex("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		[Gamma] _Metallic("Metallic", Range(0,1)) = 0
		_Smoothness("Smoothness", Range(0,1)) = 0.1
    }
    SubShader
    {
        Pass
        {
			Tags {
				"LightMode" = "ForwardBase"
			}
            CGPROGRAM
			
			#pragma target 3.0
            #include "lighting.cginc"
			
			#pragma vertex vert
			#pragma fragment frag

			//should be defined in lighting.cginc
			#if !defined(MY_LIGHTING_INCLUDED)
			#define MY_LIGHTING_INCLUDED
			#include "UnityPBSLighting.cginc"
			#endif

            ENDCG
        }
		Pass
		{
			Tags {
				"LightMode" = "ForwardAdd"
			}
			Blend One One
			ZWrite Off
			CGPROGRAM

			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fwdadd
			//same as above line
			//#pragma multi_compile DIRECTIONAL DIRECTIONAL_COOKIE POINT POINT_COOKIE SPOT
			#include "lighting.cginc"

			ENDCG
		}
    }
}
