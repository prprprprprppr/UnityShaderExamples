using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class CameraBlurryEffect : MonoBehaviour {

    public Material mat;
    [Range(0,10)]
    public int IterNum;
    [Range(0,5)]
    public int PixelSize;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int w = source.width >> PixelSize;
        int h = source.height >> PixelSize;
        RenderTexture rt = RenderTexture.GetTemporary(w,h);
        Graphics.Blit(source, rt);

        for(int i = 0; i < IterNum; i++)
        {
            RenderTexture rp = RenderTexture.GetTemporary(w, h);
            Graphics.Blit(rt, rp, mat);
            RenderTexture.ReleaseTemporary(rt);
            rt = rp;
        }

        Graphics.Blit(rt, destination);
        RenderTexture.ReleaseTemporary(rt);
        
    }
}
