Shader "Unlit/Hologram"
{
    Properties
    {
		//Input Texture
        _MainTex ("Albedo Texture", 2D) = "white" {}
		_TintColor("Tint Color", Color) = (1,1,1,1)
		_Transparency("Transparency", Range(0.0, 0.5)) = 0.25
		_CutoutThreshold("Cutout Threshold", Range(0.0, 1.0)) = 0.2
		_Distance("Distance", float) = 1
		_Amplitude("Amplitude", float) = 1
		_Speed("Speed", float) = 1
		_Amount("Amount", Range(0.0, 1.0)) = 1
    }
	//Instuctions for Unity on setting up shader	
	//Can have multiple subshaders (Multiple platform builds)
    SubShader
    {
		//Tells Unity render and explains how it should be redered
        Tags {
			//Render after the background and opaque geometry
			"Queue" = "Transparent" 
			"RenderType" = "Transparet" 
		}
		//Level Of Detail
        LOD 100
			
		//Dont render to depth buffer
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		//Single GPU instruction
        Pass
        {
            CGPROGRAM
			//process vertecies with vert function
            #pragma vertex vert
			//process fagments with frag function
            #pragma fragment frag

			//Include the https://docs.unity3d.com/Manual/SL-BuiltinFunctions.html
            #include "UnityCG.cginc"

			//contais data about verticies
			//passed into vert function
            struct appdata
            {
				//contains 4 floating point numbers (XYZW)
				//semantic binding as POSITION
                float4 vertex : POSITION;
				//contains 2 floating point positions on (UV)
				//semantic binding as texture coordinate
                float2 uv : TEXCOORD0;
            };

			//returned from vert and passed into frag
            struct v2f
            {
				//contains the UV coordinates
                float2 uv : TEXCOORD0;

				//semantic binding as Screen space position
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _TintColor;
			float _Transparency;
			float _CutoutThreshold;
			float _Distance;
			float _Amplitude;
			float _Speed;
			float _Amount;

			//vertex function
			//takes the shape of the model, potentially modifies it
			v2f vert (appdata v)
            {
				//create a new v2f to be returned (vert to frag)
                v2f o;
				
				//_Time is a unity function
				v.vertex.x += sin(_Time.y * _Speed * v.vertex.y * _Amplitude) * _Distance * _Amount;

				//convert the models local space vertics to clip space coordinates
                o.vertex = UnityObjectToClipPos(v.vertex);
				//apply the texture to the UV with Tiling and Offset from Inspector
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
                return o;
            }

			//fragment function
			//takes data from vertex function and paints the pixels
			//bound to render target (SV_Target)
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				//read in color from main texture fixed 4 color (RGBA)
                fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
				//set the alpha channel
				col.a = _Transparency;
				//if the amount of red is less then threshhold throw it out
				clip(col.r - _CutoutThreshold);
                return col;

            }
            ENDCG
        }
    }
}
