using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ImageEffectAllowedInSceneView][ExecuteInEditMode]
public class Stencil_PostProgessTEST_cameraeffect : MonoBehaviour {
    public Material mat;
    private RenderTexture buffer;
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    private void OnPostRender()
    {
        buffer = RenderTexture.GetTemporary(Screen.width, Screen.height, 24);
        Graphics.Blit(buffer, mat);
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat != null)
        {
            Graphics.SetRenderTarget(buffer.colorBuffer, buffer.depthBuffer);
            Graphics.Blit(source, destination);
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
