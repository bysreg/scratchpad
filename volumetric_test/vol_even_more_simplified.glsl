// modified by hibe (original : https://www.shadertoy.com/view/MdlyDs)
// original version By SebH

#define float2 vec2
#define float3 vec3
#define float4 vec4
#define uint2 uvec2
#define uint3 uvec3
#define uint4 uvec4

//////////////////////////////////////////////////
// Bunny volume data
//////////////////////////////////////////////////

// Packed 32^3 bunny data as 32x32 uint where each bit represents density per voxel
#define BUNNY_VOLUME_SIZE 32
const uint packedBunny[1024] = uint[1024](0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,917504u,917504u,917504u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,1966080u,12531712u,16742400u,16742400u,16723968u,16711680u,8323072u,4128768u,2031616u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,6144u,2063360u,16776704u,33553920u,33553920u,33553920u,33553920u,33520640u,16711680u,8323072u,8323072u,2031616u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,268435456u,402653184u,134217728u,201326592u,67108864u,0u,0u,7168u,2031104u,16776960u,33554176u,33554176u,33554304u,33554176u,33554176u,33554176u,33553920u,16744448u,8323072u,4128768u,1572864u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,805306368u,939524096u,402653184u,478150656u,260046848u,260046848u,260046848u,125832192u,130055680u,67108608u,33554304u,33554304u,33554304u,33554304u,33554304u,33554304u,33554304u,33554176u,16776704u,8355840u,4128768u,917504u,0u,0u,0u,0u,0u,0u,0u,0u,0u,805306368u,1056964608u,1056964608u,528482304u,528482304u,260046848u,260046848u,260046848u,130039296u,130154240u,67108739u,67108807u,33554375u,33554375u,33554370u,33554368u,33554368u,33554304u,33554304u,16776960u,8330240u,4128768u,393216u,0u,0u,0u,0u,0u,0u,0u,0u,939524096u,1040187392u,1040187392u,520093696u,251658240u,251658240u,260046848u,125829120u,125829120u,130088704u,63045504u,33554375u,33554375u,33554375u,33554407u,33554407u,33554370u,33554370u,33554374u,33554310u,16776966u,4144642u,917504u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,15360u,130816u,262017u,4194247u,33554383u,67108847u,33554415u,33554407u,33554407u,33554375u,33554375u,33554318u,2031502u,32262u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,31744u,130816u,262019u,2097151u,134217727u,134217727u,67108863u,33554415u,33554407u,33554415u,33554383u,2097102u,982926u,32262u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,31744u,130816u,524263u,117964799u,127926271u,134217727u,67108863u,16777215u,4194303u,4194303u,2097151u,1048574u,65422u,16134u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3u,31751u,130951u,524287u,252182527u,261095423u,261095423u,59768830u,2097150u,1048574u,1048575u,262143u,131070u,65534u,16134u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,7u,31751u,130959u,503840767u,520617982u,529530879u,261095423u,1048575u,1048574u,1048574u,524286u,524287u,131070u,65534u,16134u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3u,1799u,32527u,134348750u,1040449534u,1057488894u,520617982u,51380223u,1048575u,1048575u,524287u,524287u,524287u,131070u,65534u,15886u,6u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,1536u,3968u,8175u,65535u,1006764030u,1040449534u,1057488894u,50855934u,524286u,524286u,524287u,524287u,524286u,262142u,131070u,65534u,32270u,14u,6u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3968u,8160u,8191u,805371903u,2080505854u,2114191358u,101187582u,34078718u,524286u,524286u,524286u,524286u,524286u,524286u,262142u,131070u,32766u,8078u,3590u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,8128u,8176u,16383u,2013331455u,2080505854u,235143166u,101187582u,524286u,1048574u,1048574u,1048574u,1048574u,524286u,524286u,262142u,131070u,32766u,16382u,8070u,1024u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,8160u,8184u,1879064574u,2013331455u,470024190u,67371006u,524286u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,524286u,524286u,262142u,65534u,16382u,8160u,1024u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,8128u,8184u,805322750u,402718719u,134479870u,524286u,524286u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,524286u,262142u,65534u,16382u,16368u,1792u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3968u,8184u,16382u,131071u,262142u,524286u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,524286u,262142u,65534u,16382u,16368u,1792u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,1792u,8184u,16380u,65535u,262143u,524286u,524286u,1048574u,1048574u,1048575u,1048574u,1048574u,1048574u,1048574u,524286u,262142u,65534u,16376u,16368u,1792u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,8176u,16376u,32767u,262143u,524286u,1048574u,1048574u,1048575u,1048575u,1048575u,1048575u,1048574u,1048574u,524286u,262142u,32766u,16376u,8176u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,4032u,8184u,32766u,262142u,524286u,524286u,1048575u,1048574u,1048574u,1048574u,1048574u,1048574u,1048574u,524286u,262142u,32766u,16376u,8176u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,384u,8184u,32766u,131070u,262142u,524286u,1048575u,1048574u,1048574u,1048574u,1048574u,1048574u,524286u,524286u,131070u,32766u,16368u,1920u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,4080u,32764u,65534u,262142u,524286u,524286u,524286u,1048574u,1048574u,524286u,524286u,524286u,262142u,131070u,32764u,8160u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,256u,16376u,32760u,131068u,262140u,262142u,524286u,524286u,524286u,524286u,524286u,262142u,131070u,65532u,16368u,3840u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3968u,32752u,65528u,131068u,262142u,262142u,262142u,262142u,262142u,262142u,262140u,131064u,32752u,7936u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,8064u,32736u,65528u,131070u,131070u,131070u,131070u,131070u,131070u,65532u,32752u,8160u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,3456u,16376u,32764u,65534u,65534u,65534u,32766u,32764u,16380u,4048u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,48u,2680u,8188u,8188u,8188u,8188u,4092u,120u,16u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,120u,248u,508u,508u,508u,248u,240u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,96u,240u,504u,504u,504u,240u,96u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,224u,224u,224u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u);

float sampleBunny(float3 uvs)
{
    float3 voxelUvs = max(float3(0.0),min(uvs*float3(BUNNY_VOLUME_SIZE), float3(BUNNY_VOLUME_SIZE)-1.0));
    uint3 intCoord = uint3(voxelUvs);
    uint arrayCoord = intCoord.x + intCoord.z*uint(BUNNY_VOLUME_SIZE);

    // Very simple clamp to edge. It would be better to do it for each texture sample
    // before the filtering but that would be more expenssive...
    // Also adding small offset to catch cube intersection floating point error
    if(uvs.x<-0.001 || uvs.y<-0.001 || uvs.z<-0.001 ||
      uvs.x>1.001 || uvs.y>1.001 || uvs.z>1.001)
        return 0.0;

    // sample the uint representing a packed volume data of 32 voxel (1 or 0)
    uint bunnyDepthData = packedBunny[arrayCoord];
    float voxel = (bunnyDepthData & (1u<<intCoord.y)) > 0u ? 1.0 : 0.0;

    return voxel;
}


//////////////////////////////////////////////////
// Cube intersection
//////////////////////////////////////////////////

float3 worldPosTocubePos(float3 worldPos)
{
    // cube of world space size 4 with bottom face on the ground y=0
    return worldPos*0.15 + float3(0.0,-0.5,0.0);
}

// From https://www.shadertoy.com/view/4s23DR
bool cube(vec3 org, vec3 dir, out float near, out float far)
{
    // compute intersection of ray with all six bbox planes
    vec3 invR = 1.0/dir;
    vec3 tbot = invR * (-0.5 - org);
    vec3 ttop = invR * (0.5 - org);

    // re-order intersections to find smallest and largest on each axis
    vec3 tmin = min (ttop, tbot);
    vec3 tmax = max (ttop, tbot);

    // find the largest tmin and the smallest tmax
    vec2 t0 = max(tmin.xx, tmin.yz);
    near = max(t0.x, t0.y);
    t0 = min(tmax.xx, tmax.yz);
    far = min(t0.x, t0.y);

    // check for hit
    return near < far && far > 0.0;
}


//////////////////////////////////////////////////
// Main
//////////////////////////////////////////////////

// all volumetric computation are done once position has been transform into unit cube space

// Get density for a position
float getDensity(float3 cubePos)
{
    float time = 0.0f;
    float density = sampleBunny(cubePos);
    if(density==0.0) return 0.0;    // makes things a tad bit faster
    float3 noiseUV = cubePos*16.0;
    
    return density;
}

void mainImage( out float4 fragColor, in float2 fragCoord )
{
    float2 uv = fragCoord.xy / iResolution.xy;
    float time = iTime;

    // View direction in camera space
    float3 viewDir = normalize(float3((fragCoord.xy - iResolution.xy*0.5) / iResolution.y, 1.0));
    viewDir*= float3(0.9,1.0,1.0);    

    float3 color= float3(0.0, 0.0, 0.0);

    // Compute camera properties
    float  camDist = 10.0;
    float3 camUp = float3(0,1,0);
    float3 camPos = float3(camDist, 8.0, 0); // hibe : make this camera's fixed in-place
    float3 camTarget = float3(0,3.0,0); // hibe: point where the camera is looking at

    // And from them evaluted ray direction in world space
    float3 forward = normalize(camTarget - camPos);
    float3 left = normalize(cross(forward, camUp));
    float3 up = cross(left, forward);
    float3 worldDir = viewDir.x*left + viewDir.y*up + viewDir.z*forward;

    //////////////////////////////////////////////////////////////////////////////////////////
    //// Compute intersection with cube containing the bunny
    float near = 0.0;
    float far  = 0.0;
    float3 cubeSpacePos= worldPosTocubePos(camPos);
    if (cube(cubeSpacePos, worldDir, near, far))
    {
        float3 scatteredLuminance = float3(0.0,0.0,0.0);
        // float3 transmittance = float3(1.0);

        float stepSize = 0.01;
        for(float t=near; t<far; t+=stepSize)
        {
            float3 cubePos = cubeSpacePos + t*worldDir + 0.5;
            float density = getDensity(cubePos);

			scatteredLuminance += density;
        }

        // Apply volumetric on scene        
        color = scatteredLuminance;
    }

    fragColor = float4(color, 1.0);    
}