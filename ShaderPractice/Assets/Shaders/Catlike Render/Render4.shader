Shader "Unlit/Render4"
{
	Properties
	{
		_MainTex("Albedo", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		//_SpecularTint("SpecularTint", Color) = (0.5, 0.5, 0.5)
		[Gamma] _Metallic ("Metallic", Range(0,1)) = 0
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
			#pragma target 3.0 // target for PBS lighting

			//#include "UnityCG.cginc"
			//#include "UnityStandardBRDF.cginc" //Bidirectiuonal Reflectance Distribution Functions
			//#include "UnityStandardUtils.cginc"
			#include "UnityPBSLighting.cginc" // contains ^ ^^ 

			sampler2D _MainTex;
			float4 _MainTex_ST; //main textures scale and transform (used by TRANSFORM_TEX)
			float4 _Tint;
			float _Metallic;
			//float4 _SpecularTint;
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

				//get world position
				i.worldPos = mul(unity_ObjectToWorld, v.position);


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
				
				//get direction from point to camera 
				float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

				// BLINN
				//float3 reflectionDir = reflect(-lightDir, i.normal); // calc reflection of incoming from camera
				//return float4(reflectionDir * 0.5 + 0.5, 1); //view reflection dir
				//return DotClamped(viewDir, reflectionDir); //view reflected distance
				//return pow(DotClamped(viewDir, reflectionDir), _Smoothness * 100); 
				
				// BLINN-PHONG
				//float3 halfVector = normalize(lightDir + viewDir);

				//float3 specular = _SpecularTint.rgb * lightColor * pow(DotClamped(halfVector, i.normal), _Smoothness * 100);

				float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

				//METALLIC

				float3 specularTint;// = albedo * _Metallic;
				float oneMinusReflectivity;// = 1 - _Metallic;

				albedo = DiffuseAndSpecularFromMetallic(
					albedo, _Metallic, specularTint, oneMinusReflectivity
				);

				//albedo *= 1 - _SpecularTint.rgb; //specular + diffuse <= 1 (conservation of energy)
				//albedo *= 1 - max(_SpecularTint.r, max(_SpecularTint.g, _SpecularTint.b)); // ^^
				//albedo = EnergyConservationBetweenDiffuseAndSpecular(albedo, _SpecularTint.rgb, oneMinusReflectivity); //^^
				albedo *= oneMinusReflectivity;

				//float3 specular = specularTint * lightColor * pow(DotClamped(halfVector, i.normal), _Smoothness * 100);

				//float3 diffuse = albedo * lightColor * DotClamped(lightDir, i.normal);
				
				UnityLight light;
				light.color = lightColor;
				light.dir = lightDir;
				light.ndotl = DotClamped(i.normal, lightDir);

				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;

				return UNITY_BRDF_PBS(albedo, specularTint, oneMinusReflectivity, _Smoothness, i.normal, viewDir, light, indirectLight);

				//return float4(diffuse + specular, 1);


				//DotClamped returns dot product between 0 and 1
				//saturate() clamps between 0 and 1
				//return saturate(dot(float3(0, 1, 0), i.normal)); //color base on light in (0,1,0) 


				//return float4(i.normal * 0.5 + 0.5, 1); //color based on normal direction

			}

			ENDCG

			}
		}
}
