// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VGA/TN/VGA_CharaToon"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_ShadowTex("ShadowTex", 2D) = "white" {}
		_NormalMap("NormalMap", 2D) = "bump" {}
		_Emission("Emission", 2D) = "black" {}
		_Specular("Specular", 2D) = "black" {}
		_ForceShadow("ForceShadow", 2D) = "white" {}
		_shadowColor("shadowColor", Color) = (0.6618013,0.7719153,0.9811321,1)
		_shadowLine("shadowLine", Range( 0 , 1)) = 0
		_ambientAmount("ambientAmount", Range( 0 , 1)) = 0
		_ShadowJitter("ShadowJitter", Range( 0 , 1)) = 0
		_mainTexVolume("mainTexVolume", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _mainTexVolume;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float _shadowLine;
		uniform float _ShadowJitter;
		uniform sampler2D _ForceShadow;
		uniform float4 _ForceShadow_ST;
		uniform sampler2D _ShadowTex;
		uniform float4 _ShadowTex_ST;
		uniform float4 _shadowColor;
		uniform float _ambientAmount;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float3 lerpResult59 = lerp( (float4(0,0,0,0)).rgb , (tex2DNode1).rgb , _mainTexVolume);
			o.Albedo = lerpResult59;
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
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult5 = dot( ase_worldlightDir , ase_worldNormal );
			float temp_output_19_0 = ( _ShadowJitter / 2.0 );
			float2 uv_ForceShadow = i.uv_texcoord * _ForceShadow_ST.xy + _ForceShadow_ST.zw;
			float temp_output_44_0 = min( saturate( (0.0 + ((0.0 + (dotResult5 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) - max( 0.0 , ( _shadowLine - temp_output_19_0 ) )) * (1.0 - 0.0) / (min( ( _shadowLine + temp_output_19_0 ) , 1.0 ) - max( 0.0 , ( _shadowLine - temp_output_19_0 ) ))) ) , tex2D( _ForceShadow, uv_ForceShadow ).r );
			float4 lerpResult47 = lerp( ( tex2D( _Specular, uv_Specular, float2( 0,0 ), float2( 0,0 ) ) * ( 1.0 - dotResult5 ) ) , float4( (float4(0,0,0,0)).rgb , 0.0 ) , temp_output_44_0);
			float2 uv_ShadowTex = i.uv_texcoord * _ShadowTex_ST.xy + _ShadowTex_ST.zw;
			float4 lerpResult8 = lerp( ( tex2D( _ShadowTex, uv_ShadowTex ) * _shadowColor ) , tex2DNode1 , saturate( temp_output_44_0 ));
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			o.Emission = ( saturate( ( ( ase_lightColor * ase_lightColor.a ) * ( lerpResult47 + lerpResult8 ) * ( 1.0 - ( ( 1.0 - UNITY_LIGHTMODEL_AMBIENT ) * _ambientAmount ) ) ) ) + tex2D( _Emission, uv_Emission ) ).rgb;
			o.Alpha = tex2DNode1.a;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15800
14;472;1272;1000;307.6416;345.5631;1.629234;True;False
Node;AmplifyShaderEditor.RangedFloatNode;20;-1579.99,636.1478;Half;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1771.807,516.968;Float;False;Property;_ShadowJitter;ShadowJitter;10;0;Create;True;0;0;False;0;0;0.076;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1779.25,423.8541;Float;False;Property;_shadowLine;shadowLine;8;0;Create;True;0;0;False;0;0;0.687;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-1370.058,547.0559;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;2;-2053.459,-181.8157;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;4;-2015.703,-21.19531;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1222.634,625.5367;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1527.503,317.3004;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1179.771,474.0192;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-1248.702,339.4645;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;5;-1636.536,-55.09746;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1469.72,138.4373;Float;False;Constant;_Float7;Float 7;12;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1374.675,275.956;Float;False;Constant;_Float6;Float 6;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1254.119,200.5696;Float;False;Constant;_Float5;Float 5;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-791.1904,654.5074;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-943.525,583.0842;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;27;-981.582,437.7232;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;68;-966.3491,129.4953;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;28;-980.1033,317.9367;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;12;-599.0831,293.775;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-482.8134,629.452;Float;True;Property;_ForceShadow;ForceShadow;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-349.4405,295.489;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-746.689,-798.5461;Float;True;Property;_Specular;Specular;5;0;Create;True;0;0;False;0;None;None;True;0;False;black;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-92.10442,-469.6123;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;6;90.19954,620.0448;Float;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;31;-700.7646,-601.759;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-544.6389,34.00841;Float;False;Property;_shadowColor;shadowColor;7;0;Create;True;0;0;False;0;0.6618013,0.7719153,0.9811321,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;44;-78.12291,504.1132;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;-580.2229,-170.2858;Float;True;Property;_ShadowTex;ShadowTex;1;0;Create;True;0;0;False;0;None;8a22b2530cefc06479c4e1b74c6c7d79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-127.6564,-669.3802;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;51;385.8258,602.8993;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;177.256,736.5203;Float;False;Property;_ambientAmount;ambientAmount;9;0;Create;True;0;0;False;0;0;0.466;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;66;-103.5346,-53.11752;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;48;250.733,-256.3203;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-627.1425,-476.8921;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;34a2de99530694595835816b84a96f79;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-167.8125,-166.3655;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;41;860.0869,-265.2064;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;8;311.4902,-136.8237;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;573.377,606.6776;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;47;555.5776,-274.3591;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;1066.954,-252.8193;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;955.3804,-140.3802;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;53;749.0005,609.2498;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1286.322,-124.8809;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;62;255.4015,-662.3644;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;58;845.4128,-933.2666;Float;False;Constant;_Color1;Color 1;11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;1043.434,-582.5207;Float;False;Property;_mainTexVolume;mainTexVolume;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;1302.491,-816.0649;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;45;1179.45,28.81013;Float;True;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;None;eed2863fe97f2d74c9f2429745300a77;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;76;1487.247,-215.9326;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;61;727.463,-659.0607;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RelayNode;64;1576.905,362.391;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1676.571,-119.4043;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;49;1229.204,358.0646;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;995.845,-465.5511;Float;True;Property;_NormalMap;NormalMap;3;0;Create;True;0;0;False;0;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1024.469,671.3806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;59;1522.298,-696.3489;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1946.136,-163.102;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;VGA/TN/VGA_CharaToon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;10;0
WireConnection;19;1;20;0
WireConnection;21;0;9;0
WireConnection;21;1;19;0
WireConnection;22;0;9;0
WireConnection;22;1;19;0
WireConnection;5;0;2;0
WireConnection;5;1;4;0
WireConnection;27;0;21;0
WireConnection;27;1;29;0
WireConnection;68;0;5;0
WireConnection;68;1;71;0
WireConnection;68;2;70;0
WireConnection;68;3;69;0
WireConnection;68;4;70;0
WireConnection;28;0;25;0
WireConnection;28;1;22;0
WireConnection;12;0;68;0
WireConnection;12;1;28;0
WireConnection;12;2;27;0
WireConnection;12;3;13;0
WireConnection;12;4;14;0
WireConnection;16;0;12;0
WireConnection;31;0;5;0
WireConnection;44;0;16;0
WireConnection;44;1;43;1
WireConnection;40;0;30;0
WireConnection;40;1;31;0
WireConnection;51;0;6;0
WireConnection;66;0;44;0
WireConnection;48;0;18;0
WireConnection;7;0;46;0
WireConnection;7;1;35;0
WireConnection;8;0;7;0
WireConnection;8;1;1;0
WireConnection;8;2;66;0
WireConnection;52;0;51;0
WireConnection;52;1;50;0
WireConnection;47;0;40;0
WireConnection;47;1;48;0
WireConnection;47;2;44;0
WireConnection;74;0;41;0
WireConnection;74;1;41;2
WireConnection;32;0;47;0
WireConnection;32;1;8;0
WireConnection;53;0;52;0
WireConnection;42;0;74;0
WireConnection;42;1;32;0
WireConnection;42;2;53;0
WireConnection;62;0;1;0
WireConnection;60;0;58;0
WireConnection;76;0;42;0
WireConnection;61;0;62;0
WireConnection;55;0;76;0
WireConnection;55;1;45;0
WireConnection;49;0;1;4
WireConnection;59;0;60;0
WireConnection;59;1;61;0
WireConnection;59;2;63;0
WireConnection;0;0;59;0
WireConnection;0;1;54;0
WireConnection;0;2;55;0
WireConnection;0;9;49;0
ASEEND*/
//CHKSM=E5E5598477F766183977C3613B2A997683C9FA75