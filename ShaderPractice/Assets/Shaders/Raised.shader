﻿Shader "Custom/Raised"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NoiseTex("Noise", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows
		#pragma vertex vert
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _NoiseTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        #pragma instancing_options assumeuniformscaling

        UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_DEFINE_INSTANCED_PROP(float, _Moved)
		UNITY_DEFINE_INSTANCED_PROP(float, _PositionX)
		UNITY_DEFINE_INSTANCED_PROP(float, _PositionZ)
        UNITY_INSTANCING_BUFFER_END(Props)

		void vert(inout appdata_full v)
		{
			float4 noise = tex2Dlod(_NoiseTex, float4(float2(_PositionX % 1, _PositionZ % 1), 0, 0));

			//v.vertex.xyz *= 1 - UNITY_ACCESS_INSTANCED_PROP(Props, _Moved);
			v.vertex.xyz *= noise.r * _Moved;
		
			//v.vertex.y -= 1 * UNITY_ACCESS_INSTANCED_PROP(Props, _Moved);
			v.vertex.y -= noise.r * _Moved;
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
