using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Erase : MonoBehaviour {
    
    public Shader EraseShader;
    [Range(0.001f,1.0f)]
    public float FlakeAmount;
    [Range(0.0f,1.0f)]
    public float FlakeOpacity;

    private Material Snowmat;
    private Material Erasemat;
    private RenderTexture tex;

    void Start ()
    {
        Snowmat = GetComponent<MeshRenderer>().material;
        Erasemat = new Material(EraseShader);
        
        tex = new RenderTexture(500, 500, 0, RenderTextureFormat.ARGBFloat);
        Erasemat.SetFloat("_FlakeAmount", FlakeAmount);
        Erasemat.SetFloat("_FlakeOpacity", FlakeOpacity);
    }
	
	// Update is called once per frame
	void Update ()
    {
        tex = (RenderTexture)Snowmat.GetTexture("_TraceTex");
        RenderTexture temp = RenderTexture.GetTemporary(tex.width, tex.height, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(tex, temp);
        Graphics.Blit(temp, tex, Erasemat);
        RenderTexture.ReleaseTemporary(temp);
    }
}
