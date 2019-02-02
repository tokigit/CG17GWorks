// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VGA/TN/VGA_CharaToon"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Emission("Emission", 2D) = "black" {}
		_Specular("Specular", 2D) = "black" {}
		_ForceShadow("ForceShadow", 2D) = "white" {}
		_shadowColor("shadowColor", Color) = (0.6618013,0.7719153,0.9811321,1)
		_shadowLine("shadowLine", Range( 0 , 1)) = 0
		_ShadowJitter("ShadowJitter", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float4 _shadowColor;
		uniform float _shadowLine;
		uniform float _ShadowJitter;
		uniform sampler2D _ForceShadow;
		uniform float4 _ForceShadow_ST;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = i.worldNormal;
			float dotResult5 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_39_0 = saturate( dotResult5 );
			float temp_output_19_0 = ( _ShadowJitter / 2.0 );
			float4 temp_cast_3 = (saturate( (0.0 + (temp_output_39_0 - max( 0.0 , ( _shadowLine - temp_output_19_0 ) )) * (1.0 - 0.0) / (min( ( _shadowLine + temp_output_19_0 ) , 1.0 ) - max( 0.0 , ( _shadowLine - temp_output_19_0 ) ))) )).xxxx;
			float2 uv_ForceShadow = i.uv_texcoord * _ForceShadow_ST.xy + _ForceShadow_ST.zw;
			float4 lerpResult8 = lerp( ( tex2DNode1 * UNITY_LIGHTMODEL_AMBIENT * _shadowColor ) , tex2DNode1 , min( temp_cast_3 , tex2D( _ForceShadow, uv_ForceShadow ) ));
			c.rgb = ( float4( ase_lightColor.rgb , 0.0 ) * ( ( tex2D( _Specular, uv_Specular, float2( 0,0 ), float2( 0,0 ) ) * ( 1.0 - temp_output_39_0 ) ) + saturate( lerpResult8 ) ) ).rgb;
			c.a = tex2DNode1.a;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Albedo = float4(0,0,0,0).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = tex2D( _Emission, uv_Emission ).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
199;411;1513;472;1598.846;796.3091;2.354317;True;True
Node;AmplifyShaderEditor.RangedFloatNode;10;-1771.807,516.968;Float;False;Property;_ShadowJitter;ShadowJitter;7;0;Create;True;0;0;False;0;0;0.39;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1579.99,636.1478;Half;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;4;-1629.348,-19.44998;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-1683.168,-169.21;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-1370.058,547.0559;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1779.25,423.8541;Float;False;Property;_shadowLine;shadowLine;6;0;Create;True;0;0;False;0;0;0.16;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1234.464,147.8694;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-1351.107,-114.0703;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1222.634,625.5367;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1179.771,474.0192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-1233.816,237.7474;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;28;-980.1033,317.9367;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-1128.085,-68.73062;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-711.8545,652.524;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;27;-981.582,437.7232;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-818.0046,579.3849;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;12;-546.2712,258.1449;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-337.788,414.063;Float;True;Property;_ForceShadow;ForceShadow;4;0;Create;True;0;0;False;0;None;8a22b2530cefc06479c4e1b74c6c7d79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-762.0934,-184.3059;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;34a2de99530694595835816b84a96f79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-328.64,256.9474;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;6;-747.298,8.202904;Float;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;35;-759.5956,91.49112;Float;False;Property;_shadowColor;shadowColor;5;0;Create;True;0;0;False;0;0.6618013,0.7719153,0.9811321,1;0.6618013,0.7719153,0.9811321,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;44;-12.29583,264.845;Float;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-361.2226,46.62865;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;30;-775.7776,-483.6213;Float;True;Property;_Specular;Specular;3;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;-121.3274,-34.62635;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;31;-712.0326,-270.411;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;118.356,-35.10359;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-49.54368,-281.538;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;41;244.2648,-439.3338;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;32;312.2321,-207.8196;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;541.8648,-292.1339;Float;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1024.469,671.3806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;73.38046,-629.9188;Float;True;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;None;eed2863fe97f2d74c9f2429745300a77;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;596.0244,-644.4137;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;900.9346,-400.475;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;VGA/TN/VGA_CharaToon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;10;0
WireConnection;19;1;20;0
WireConnection;5;0;2;0
WireConnection;5;1;4;0
WireConnection;21;0;9;0
WireConnection;21;1;19;0
WireConnection;22;0;9;0
WireConnection;22;1;19;0
WireConnection;28;0;25;0
WireConnection;28;1;22;0
WireConnection;39;0;5;0
WireConnection;27;0;21;0
WireConnection;27;1;29;0
WireConnection;12;0;39;0
WireConnection;12;1;28;0
WireConnection;12;2;27;0
WireConnection;12;3;13;0
WireConnection;12;4;14;0
WireConnection;16;0;12;0
WireConnection;44;0;16;0
WireConnection;44;1;43;0
WireConnection;7;0;1;0
WireConnection;7;1;6;0
WireConnection;7;2;35;0
WireConnection;8;0;7;0
WireConnection;8;1;1;0
WireConnection;8;2;44;0
WireConnection;31;0;39;0
WireConnection;37;0;8;0
WireConnection;40;0;30;0
WireConnection;40;1;31;0
WireConnection;32;0;40;0
WireConnection;32;1;37;0
WireConnection;42;0;41;1
WireConnection;42;1;32;0
WireConnection;0;0;18;0
WireConnection;0;2;45;0
WireConnection;0;9;1;4
WireConnection;0;13;42;0
ASEEND*/
//CHKSM=DCC3457D201CC9C424D53BD43152019B47EBD54A