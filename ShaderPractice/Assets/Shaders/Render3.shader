Shader "Custom/Render3"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_DetailTex("Texture", 2D) = "grey" {}
		_Tint("Tint", Color) = (1,1,1,1)
	}

		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex, _DetailTex;
			float4 _MainTex_ST, _DetailTex_ST; //main textures scale and transform (used by TRANSFORM_TEX)
		
			float4 _Tint;

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
				float2 uvDetail : TEXCOORD1;
			};

			struct Interpolations {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvDetail : TEXCOORD1;
			};

			Interpolations vert(VertexData v)
			{
				Interpolations i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);
				//i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				return i;
			}

			float4 frag(Interpolations i) : SV_TARGET
			{
				float4 color = tex2D(_MainTex, i.uv) * _Tint;
				color *= tex2D(_DetailTex, i.uvDetail) * unity_ColorSpaceDouble; //correct for gamma/linear color space
				return color;
			}
			ENDCG

			}
		}
}
