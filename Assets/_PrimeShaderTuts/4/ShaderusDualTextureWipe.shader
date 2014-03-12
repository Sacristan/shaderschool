Shader "_Shader/ShaderusDualTextureWipe" {
	Properties {
		_MainTex ( "Main Texture", 2D) = "white" {}
		_SecondTex ( "Main Texture", 2D) = "white" {}
		_TextureMix ( "Texture Mix", Range(0.0,1.0)) = 0.5
	}
	SubShader {
		Tags {"Queue" = "Geometry"}
		
		Pass{
			CGPROGRAM
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform sampler2D _SecondTex;
//				uniform float4 _MainTex_ST; //-> replaced w UNITY_MATRIX_TEXTURE0
//				uniform float4 _SecondTex_ST; //-> replaced w UNITY_MATRIX_TEXTURE1
				uniform fixed _TextureMix;
				
				struct vertexInput{
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};
				
				struct fragmentInput{
					float4 pos : SV_POSITION;
					fixed2 uv : TEXCOORD0;
					fixed2 uv2 : TEXCOORD1;
					fixed2 localPos : TEXCOORD2;
				};
				
				fragmentInput vert( vertexInput i ){
					fragmentInput o;
					o.localPos = i.vertex.xy + fixed2(0.5, 0.5);
					o.pos = mul( UNITY_MATRIX_MVP, i.vertex);
					o.uv = mul( UNITY_MATRIX_TEXTURE0, i.texcoord);
					o.uv2 = mul( UNITY_MATRIX_TEXTURE1, i.texcoord);
					
//					o.uv = TRANSFORM_TEX(i.texcoord, _MainTex);//-> replaced w UNITY_MATRIX_TEXTURE0
//					o.uv2 = TRANSFORM_TEX(i.texcoord, _SecondTex);//-> replaced w UNITY_MATRIX_TEXTURE1
					
					return o;
				}
				
				half4 frag(fragmentInput i ) : COLOR{
					fixed distanceFromMixPoint = _TextureMix - i.localPos.x;
					
					if(abs(distanceFromMixPoint) < 0.2){
						fixed mixFactor = 1 - (distanceFromMixPoint + 0.2) / 0.4;
						return lerp(tex2D(_MainTex, i.uv), tex2D(_SecondTex, i.uv2), mixFactor);
					}
					else{
						if(i.localPos.x < _TextureMix){
							return tex2D(_MainTex, i.uv);
						}
						else{
							return tex2D(_SecondTex, i.uv2);
						}
					}
				}
				
			ENDCG
		}
	}
	FallBack "Diffuse"
}