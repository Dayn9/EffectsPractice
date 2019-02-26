Shader "Unlit/Render4"
{
	Properties
	{
		_MainTex("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
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

			//#include "UnityCG.cginc"
			#include "UnityStandardBRDF.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST; //main textures scale and transform (used by TRANSFORM_TEX)
			float4 _Tint;

			struct VertexData {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Interpolations {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;

			};

			Interpolations vert(VertexData v)
			{
				Interpolations i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.normal = UnityObjectToWorldNormal(v.normal);
				/*
				DOES THE SAME AS THE ABOVE LINE UUUUUFFGGGH
				i.normal = mul(
					transpose((float3x3)unity_WorldToObject),
					v.normal); //translate to world normal
				
				i.normal = normalize(i.normal);
				*/
				return i;
			}

			float4 frag(Interpolations i) : SV_TARGET
			{
				i.normal = normalize(i.normal);//renormalize (not performant but better)
				
				//get the main light source direction (XYZ components only)
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;

				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

				float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
				return float4(diffuse, 1);


				//DotClamped returns dot product between 0 and 1
				//saturate() clamps between 0 and 1
				//return saturate(dot(float3(0, 1, 0), i.normal)); //color base on light in (0,1,0) 


				//return float4(i.normal * 0.5 + 0.5, 1); //color based on normal direction
			}

			ENDCG

			}
		}
}
