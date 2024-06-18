Shader "Custom/GridShader"
{
    Properties
    {
        _Color("Grid Color", Color) = (0, 0, 0, 1)
        _BackgroundColor("Background Color", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "white" {}
        _GridSize("Grid Size", Float) = 10.0
        _LineThickness("Line Thickness", Float) = 1.0
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

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float2 uv : TEXCOORD0;
                    float4 vertex : SV_POSITION;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _Color;
                float4 _BackgroundColor;
                float _GridSize;
                float _LineThickness;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return o;
                }

                half4 frag(v2f i) : SV_Target
                {
                    half4 bgColor = _BackgroundColor;

                    float2 grid = abs(frac(i.uv * _GridSize - 0.5) - 0.5) / fwidth(i.uv * _GridSize) * _LineThickness;
                    float gridLine = min(grid.x, grid.y);
                    float gridPattern = 1.0 - smoothstep(0.0, 1.0, gridLine);

                    half4 gridColor = _Color * gridPattern;
                    return lerp(bgColor, gridColor, gridPattern);
                }
                ENDCG
            }
        }
            FallBack "Diffuse"
}
