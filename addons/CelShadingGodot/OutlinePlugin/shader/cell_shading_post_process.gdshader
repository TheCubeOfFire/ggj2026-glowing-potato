//
// https://www.shadertoy.com/view/Xdf3Rf

shader_type spatial;
render_mode unshaded, fog_disabled, cull_disabled;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
uniform sampler2D normal_map_roughness : hint_normal_roughness_texture;
#endif
uniform sampler2D depth: hint_depth_texture;
uniform sampler2D current_texture : hint_screen_texture;

uniform float threshold;
uniform float depth_threshold;
uniform float contrast;
uniform float intensity;
uniform float max_distance_threshold;
uniform vec4 outline_colors;
uniform int iOutlineSize;

const mat3 diff_kernel_h = mat3(
	vec3(0.0, -0.0, 0.0),
	vec3(-1.0, 0.0, 1.0),
	vec3(0.0, -0.0, 0.0)
);
const mat3 diff_kernel_v = mat3(
	vec3(0.0, -1.0, 0.0),
	vec3(-0.0, 0.0, -0.0),
	vec3(0.0, 1.0, 0.0)
);

const mat3 sobel_filter_v = mat3(
	vec3(-1.0, 0.0, 1.0),
	vec3(-2.0, 0.0, 2.0),
	vec3(-1.0, 0.0, 1.0)
);

const mat3 sobel_filter_h = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

mat3 constructPixelMatrix(sampler2D samplerToUse, ivec2 screen_coord_pixel, float fMulConvert, float fAddConvert, vec3 convertToFloat)
{
	mat3 pixelMat;
	for (int iRow = 0; iRow < 3; iRow++)
	{
		for (int iCol = 0; iCol < 3; iCol++)
		{
			pixelMat[iRow][iCol] = dot(fMulConvert * texelFetch(samplerToUse, screen_coord_pixel + ivec2(iRow - 1, iCol - 1) * iOutlineSize, 0).xyz + fAddConvert, convertToFloat);
		}
	}

	return pixelMat;
}

mat3 constructPixelMatrixND(sampler2D samplerToUse, ivec2 screen_coord_pixel, float fMulConvert, float fAddConvert, vec3 convertToFloat)
{
	mat3 pixelMat;
	for (int iRow = 0; iRow < 3; iRow++)
	{
		for (int iCol = 0; iCol < 3; iCol++)
		{
			pixelMat[iRow][iCol] = dot(fMulConvert * texelFetch(samplerToUse, screen_coord_pixel + ivec2(iRow - 1, iCol - 1), 0).xyz + fAddConvert, convertToFloat);
		}
	}

	return pixelMat;
}

float applyKernel(mat3 sobelKernel, mat3 pixelValue)
{
	float sobelValue = 0.0f;
	for (int iRow = 0; iRow < 3; iRow++)
	{
		for (int iCol = 0; iCol < 3; iCol++)
		{
			sobelValue += sobelKernel[2-iRow][2-iCol] * pixelValue[iRow][iCol];
		}
	}
	return sobelValue / 9.0f;
}

float linearizeDepth(vec2 vScreenUV, mat4 mInvProj, float fDepth)
{
#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
	vec3 ndc = vec3(vScreenUV, fDepth) * 2.0 - 1.0;
#else
	vec3 ndc = vec3(vScreenUV * 2.0 - 1.0, fDepth);
#endif
	vec4 vView = mInvProj * vec4(ndc, 1.0);
	return -vView.z/vView.w;
}

mat3 linearizeMatDepth(vec2 vScreenUV, mat4 mInvProj, mat3 pixels)
{
	mat3 pixelsLinearized;
	for (int iRow = 0; iRow < 3; iRow++)
	{
		for (int iCol = 0; iCol < 3; iCol++)
		{
			pixelsLinearized[iRow][iCol] = linearizeDepth(vScreenUV, mInvProj, pixels[iRow][iCol]);
		}
	}

	return pixelsLinearized;
}

void fragment()
{
	ivec2 screen_coord_pixel = ivec2(SCREEN_UV.xy * VIEWPORT_SIZE.xy);

	//
	// Apply depth filter
	mat3 depthPixels = constructPixelMatrix(depth, screen_coord_pixel, 1.0, 0.0, vec3(1.0, 0.0, 0.0));
	depthPixels = linearizeMatDepth(SCREEN_UV, INV_PROJECTION_MATRIX, depthPixels);

	float depthHDiff = applyKernel(diff_kernel_h, depthPixels);
	float depthVDiff = applyKernel(diff_kernel_v, depthPixels);
	float fDiffDepth = sqrt(depthVDiff * depthVDiff + depthHDiff * depthHDiff);
	float newThreshold = mix(depth_threshold, 10.0, depthPixels[1][1] / max_distance_threshold);

	//
	// Sobel on depth
	float dsobelVdepth = abs(applyKernel(sobel_filter_v, depthPixels));
	float dsobelHdepth = abs(applyKernel(sobel_filter_h, depthPixels));
	float fSobelDepth = sqrt(dsobelVdepth * dsobelVdepth + dsobelHdepth * dsobelHdepth);

	fSobelDepth = clamp(intensity * pow(fSobelDepth, contrast) - depth_threshold, 0.0, 1.0);

	//
	// Apply filter
#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
	mat3 normalPixel = constructPixelMatrixND(normal_map_roughness, screen_coord_pixel, 2.0, -1.0, vec3(0.2126, 0.7152, 0.0722));
	float vSobelVValue = applyKernel(sobel_filter_v, normalPixel);
	float vSobelHValue = applyKernel(sobel_filter_h, normalPixel);

	float fEdge = sqrt(vSobelVValue * vSobelVValue + vSobelHValue * vSobelHValue);
	//fEdge *= fDEdge;

	//ALBEDO.xyz = texelFetch(normal_map_roughness, screen_coord_pixel, 0).xyz;
	float thresholdedGradiant = clamp(intensity * pow(fEdge, contrast) - threshold, 0.0, 1.0);
	//float thresholdedGradiant = fGradiant > threshold ? fGradiant : 0.0;
#endif

#if CURRENT_RENDERER == RENDERER_FORWARD_PLUS
	thresholdedGradiant += fSobelDepth;
#else
    float thresholdedGradiant = fSobelDepth;
#endif

	vec3 currentColor = texture(current_texture, SCREEN_UV).xyz;
	vec3 newOutlineColors = mix(currentColor, outline_colors.xyz, outline_colors.w);
	currentColor = mix(currentColor, newOutlineColors, clamp(thresholdedGradiant, 0.0, 1.0));

	ALBEDO.xyz = vec3(currentColor);
}
