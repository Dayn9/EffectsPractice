
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Render2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

			sampler2D _MainTex;
			float4 _MainTex_ST; //main textures scale and transform (used by TRANSFORM_TEX)
			float4 _Tint;

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct Interpolations {
				float4 position : SV_POSITION;
				float2 uv : UV;
			};

			Interpolations vert (VertexData v)
            {
				Interpolations i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				//i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				return i;
            }

            float4 frag (Interpolations i) : SV_TARGET
            {
				return tex2D(_MainTex, i.uv) * _Tint;
            }
            ENDCG
			}
		}
}
