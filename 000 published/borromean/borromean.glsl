// exponential smooth minumum of a and b, with smoothing factor k.
float smoothMin( float a, float b, float k)
{
    float r = 1. + exp2(-abs(a-b)/k);
    return min(a,b) - k * log2(r);
}

float sdLink(vec3 position, float height, float majorRadius, float minorRadius)
{
    vec3 q = vec3(position.x, max(abs(position.y) - height, 0.), position.z);
    return length(vec2(length(q.xy) - majorRadius, q.z)) - minorRadius;
}

float map(in vec3 position)
{
    float r2 = 8.;
    float k = 2.;
    float signedDistance = sdLink(position, 18., 18., r2);
    signedDistance = smoothMin(signedDistance, sdLink(position.yzx, 18., 18., r2), k);
    signedDistance = smoothMin(signedDistance, sdLink(position.zxy, 18., 18., r2), k);
    return signedDistance;
}
