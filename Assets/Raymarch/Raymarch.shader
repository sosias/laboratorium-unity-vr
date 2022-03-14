Shader "Unlit/Raymarch"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            #define MAX_STEPS 100
            #define MAX_DIST 100
            #define SURF_DIST 1e-3

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 ro : TEXCOORD2;
                float3 hitPos : TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                o.ro = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos,1)); // world space
                o.hitPos = v.vertex; // object space
                return o;
            }

            float GetDist(float3 p) {
                float d = length(p) - .5; // sphere
                d = length(float2(length(p.xy) - .5, p.z)) - .1; //torus

                return d;
            }

            float Raymarch(float3 ro, float3 rd) {
                float dO = 0; // distance from origin (marched)
                float dS; //distance surface
                for (int i = 0; i < MAX_STEPS; i++) {
                    float3 p = ro + dO * rd; // position
                    dS = GetDist(p);
                    dO += dS;
                    if (dS<SURF_DIST || dO>MAX_DIST) break;
                }
                return dO;
            }

            float3 GetNormal(float3 p) {
                float2 e = float2(1e-2, 0);
                float3 n = GetDist(p) - float3(
                    GetDist(p - e.xyy),
                    GetDist(p - e.yxy),
                    GetDist(p - e.yyx)
                    );
                return normalize(n);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv-0.5;
                float3 ro = i.ro; // ray origin
                float3 rd = normalize(i.hitPos-ro); // ray distance

                float d = Raymarch(ro, rd);
                fixed4 col = 0;

                if (d >= MAX_DIST) {
                    discard;
                }
                else {
                    float3 p = ro + rd * d;
                    float3 n = GetNormal(p);
                    col.rgb = n;
                }

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
