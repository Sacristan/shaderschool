Shader "_Shader/Shaderus2" {
	Properties {
		_Color ("Tint Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader {
		Tags {"Queue" = "Transparent"}
		ZWrite Off //Should we write to the depth buffer?
		//Blend modes equation:
			//SrcFactor * fragment_output + DstFactor * pixel_color_in_framebuffer;
		//Blend {code for SrcFactor} {code for DstFactor}
			
		Blend SrcAlpha OneMinusSrcAlpha //alpha blending
//		Blend One OneMinusSrcAlpha		//premultiplied alpha bblending
//		Blend One One					//additive
//		Blend SrcAlpha One				//additive blending
//		Blend OneMinusDstColor One		//soft additive
//		Blend DstColor Zero				//multiplicative
//		Blend DstColor SrcColor			//2x multiplicative
//		Blend Zero SrcAlpha				//multiplicative blending for attenuation by the fragment's alpha
		
//		BlendOp Min
//		BlendOp Max
		
		Pass{
			CGPROGRAM
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				uniform fixed4 _Color;

				struct vertexInput{
					float4 vertex : POSITION; //position (in object coordinates, i.e. local or model coordinates)
					float4 tangent : TANGENT; //vector orthogonal to the surface normal
					float3 normal : NORMAL; //surface normal vector (in object coordinates; usually normalised to unity length)
					float4 textcoord : TEXCOORD0; //0th set of texture coordinates (aka UV;  between 0 and 1)
					float4 textcoord1 : TEXCOORD1; //1th set of texture coordinates (aka UV;  between 0 and 1)
					fixed4 color : COLOR; //vertex color
				};

				struct fragmentInput{
					float4 pos : SV_POSITION;
					float4 color : COLOR0;
				};

				fragmentInput vert(vertexInput i){
					fragmentInput o;
					o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
					o.color = _Color;
					
					//debug: uncomment the desired item to debug then return i.color directly in the fragment shader
//					o.color = i.textcoord;
//					o.color = i.textcoord1;
//					o.color = i.vertex;
//					o.color = i.vertex + float4(0.5,0.5,0.5,0.0); //we add 0.5 to offset if the model verts go from -0.5 -> 0.5
//					o.color = i.tangent;
//					o.color = float4(i.normal * 0.5 + 0.5, 1.0); //scale and bias the normal to get it in the range of 0 -> 1
//					o.color = i.color; //vertex colors
					
					return o;
				}

				half4 frag(fragmentInput i) : COLOR{
					return i.color;
				}
			ENDCG
		}
	}
	FallBack "Diffuse"
}