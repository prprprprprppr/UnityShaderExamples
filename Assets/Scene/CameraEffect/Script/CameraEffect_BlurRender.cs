using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode][ImageEffectAllowedInSceneView]
public class CameraEffect_BlurRender : MonoBehaviour {

    public Material mat;
    public int Intensity = 5;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat != null)
        {
            RenderTexture rt = RenderTexture.GetTemporary(source.width,source.height,0,RenderTextureFormat.ARGBFloat);
            for (int i = 0; i < Intensity; i++)
            {
                Graphics.Blit(source, rt, mat, 0);
                Graphics.Blit(rt, source, mat, 1);
            }
            Graphics.Blit(rt, destination);
            RenderTexture.ReleaseTemporary(rt);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
