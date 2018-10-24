using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlobalSnow_Camera : MonoBehaviour {
    
    public Shader shader;
    public float SnowScale = 10.0f;
    public Texture2D SnowTex;

    private Material mat;
    private Camera cam;

	// Use this for initialization
	void Start () {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.DepthNormals;
        mat = new Material(shader);
	}
	
	// Update is called once per frame
	void Update () {
        mat.SetFloat("_SnowScale", SnowScale);
        mat.SetTexture("_SnowTex", SnowTex);
        mat.SetMatrix("_cammatrix", cam.cameraToWorldMatrix);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination,mat);
    }
}
