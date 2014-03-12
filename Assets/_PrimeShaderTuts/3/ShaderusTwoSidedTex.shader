Shader "_Shader/ShaderusTwoSidedTex" {
	Properties {
		_MainTex ( "Main Texture", 2D) = "white" {}
	}
	SubShader {
		Tags {"Queue" = "Transparent"}
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass{
			Cull Front
			CGPROGRAM
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				
//----------------------------------------------------//				
//				fixed [-2, 2]			-> colors	  //
//				half  [-60k;60k]		-> more data  //
//				float [OS dependent]	-> position   //
//----------------------------------------------------//
				
				uniform sampler2D _MainTex;
//				uniform float4 _MainTex_ST; //replaced with UNITY_MATRIX_TEXTURE0
				
				struct vertexInput{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};
				
				struct fragmentInput{
					float4 pos : SV_POSITION;
					fixed2 uv : TEXCOORD0;
				};
				
				fragmentInput vert( vertexInput i ){
					fragmentInput o;
					o.pos = mul( UNITY_MATRIX_MVP, i.vertex);
					o.uv = mul( UNITY_MATRIX_TEXTURE0, i.texcoord);
//					o.uv = TRANSFORM_TEX(i.texcoord, _MainTex); //replaced with UNITY_MATRIX_TEXTURE0
					
					return o;
				}
				
				half4 frag(fragmentInput i ) : COLOR{
					return tex2D(_MainTex, i.uv);
				}
				
			ENDCG
		}
		Pass{
			Cull BACK
			CGPROGRAM
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				
//----------------------------------------------------//				
//				fixed [-2, 2]			-> colors	  //
//				half  [-60k;60k]		-> more data  //
//				float [OS dependent]	-> position   //
//----------------------------------------------------//
				
				uniform sampler2D _MainTex;
//				uniform float4 _MainTex_ST; //replaced with UNITY_MATRIX_TEXTURE0
				
				struct vertexInput{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};
				
				struct fragmentInput{
					float4 pos : SV_POSITION;
					half2 uv : TEXCOORD0;
				};
				
				fragmentInput vert( vertexInput i ){
					fragmentInput o;
					o.pos = mul( UNITY_MATRIX_MVP, i.vertex);
					o.uv = mul( UNITY_MATRIX_TEXTURE0, i.texcoord);
//					o.uv = TRANSFORM_TEX(i.texcoord, _MainTex); //replaced with UNITY_MATRIX_TEXTURE0
					
					return o;
				}
				
				half4 frag(fragmentInput i ) : COLOR{
					return tex2D(_MainTex, i.uv);
				}
				
			ENDCG
		}
	}
	FallBack "Diffuse"
}