Shader "_Shader/VertexLit" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Diffuse Material Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "LightMode"="ForwardBase" }
		Pass{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "../Shared/Sac.cginc"
			
			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			uniform fixed4 _LightColor0;
			
			struct vertexInput{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};
			
			struct fragmentInput{
				float4 pos : SV_POSITION;
				float4 color : COLOR0;
				fixed2 uv : TEXCOORD0;
			};
			
			fragmentInput vert(vertexInput i){
				fragmentInput o;
				o.pos = mul( UNITY_MATRIX_MVP, i.vertex);
				o.uv = mul( UNITY_MATRIX_TEXTURE0, i.texcoord);
				
				//normal in world space
				float3 normalDir = NORMAL_TO_WORLD(i.normal);
				//only dealing with single directional light
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				//calculate diffues lightuing = IncomingLight * DiffuseColor * (Normal dot Light)
				//use of max is cause in case if the dot is negative which would indicate the light is on the wrong side
				float ndotl = dot(normalDir, lightDir );
				float3 diffuse = _LightColor0.xyz * _Color.rgb * max(0.0, ndotl);
				
				o.color = half4(diffuse,1.0);
				
				return o;
			}
			
			half4 frag(fragmentInput i) : COLOR{
				return tex2D(_MainTex, i.uv) * i.color;
			}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
