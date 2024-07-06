precision mediump float;

uniform sampler2D uTexture;
uniform float uBlurRadius;
uniform vec2 uCenter;
uniform float uRadius;

vec4 blur(vec2 uv) {
  vec4 color = vec4(0.0);
  float total = 0.0;
  for (float x = -4.0; x <= 4.0; x++) {
    for (float y = -4.0; y <= 4.0; y++) {
      vec2 offset = vec2(x, y) * uBlurRadius;
      color += texture2D(uTexture, uv + offset);
      total += 1.0;
    }
  }
  return color / total;
}

void main() {
  vec2 uv = gl_FragCoord.xy / uResolution.xy;
  vec4 originalColor = texture2D(uTexture, uv);
  float distance = length(uv - uCenter);

  if (distance < uRadius) {
    gl_FragColor = originalColor;
  } else {
    gl_FragColor = blur(uv);
  }
}
