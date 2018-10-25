using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode][ImageEffectAllowedInSceneView]
public class Example_Unlit_OutlineWithSobelCameraSampler : MonoBehaviour {

    public Material mat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat != null)
        {
            RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(source, rt, mat);
            Shader.SetGlobalTexture("_Global_OutlineWithSobelTexture", rt);
            RenderTexture.ReleaseTemporary(rt);
        }
        Graphics.Blit(source, destination);
    }
}
