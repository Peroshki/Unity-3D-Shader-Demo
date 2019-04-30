// Adapted from Febbuci's online tutorial https://www.febucci.com/2018/09/dissolve-shader/
// A simple surface shader which uses a pre-generated noise texture to lerp the alpha channel between 1 and 0
// across the texture, achieving a "dissolving effect"
// The shader also uses a vertex component to expand and retract the object.

Shader "Custom/Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        //Dissolve/displace properties
        _DissolveTexture("Dissolve Texture", 2D) = "white" {} 
        _Amount("Dissolve Amount", Range(0,1)) = 0
        _Displace("Amount", Range(0,10)) = 0 //slider
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float displacementValue;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Dissolve/displace properties
        float _Displace;
        sampler2D _DissolveTexture;
        half _Amount;

        void vert(inout appdata_full v, out Input o) 
        {
            // How much we expand, based on our DisplacementTexture
            float value = tex2Dlod(_DissolveTexture, v.texcoord*7).x * _Displace;
            v.vertex.xyz += v.normal.xyz * value * .3; //Expand

            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.displacementValue = value; //Pass this info to the surface shader
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //Dissolve function
            half dissolve_value = tex2D(_DissolveTexture, IN.uv_MainTex).r;
            clip(dissolve_value - _Amount);

            // Emit a white border with size 0.05
            o.Emission = fixed3(1, 1, 1) * step( dissolve_value - _Amount, 0.01f);

            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = lerp(c.rgb * c.a, float3(0, 0, 0), IN.displacementValue); // lerp based on the displacement

            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
