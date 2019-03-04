﻿Shader "Unlit/myLighting"
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
		Tags {
				"RenderType" = "Opaque"
				"LightMode" = "ForwardBase" //gives access to main forward light
		}
			LOD 100

			Pass
			{

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0 

			#include "UnityPBSLighting.cginc" 

			sampler2D _MainTex;
			float4 _MainTex_ST; 
			float4 _Tint;
			float _Metallic;
			float _Smoothness;

			struct VertexData {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolations {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;

			};

			Interpolations vert(VertexData v)
			{
				Interpolations i;
				i.position = UnityObjectToClipPos(v.position);
				i.worldPos = mul(unity_ObjectToWorld, v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.normal = UnityObjectToWorldNormal(v.normal);
				return i;
			}

			float4 frag(Interpolations i) : SV_TARGET
			{
				i.normal = normalize(i.normal);

				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
				
				float3 specularTint;
				float oneMinusReflectivity;
				albedo = DiffuseAndSpecularFromMetallic( albedo, _Metallic, specularTint, oneMinusReflectivity);
				albedo *= oneMinusReflectivity;

				UnityLight light;
				light.color = lightColor;
				light.dir = lightDir;
				light.ndotl = DotClamped(i.normal, lightDir);

				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;

				return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, light, indirectLight);
			}

			ENDCG

			}

    }
}
