using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlineCameraEffect : MonoBehaviour {

    private Material mat;

	// Use this for initialization
	void Start () {
        mat = new Material(Shader.Find("Hidden/OutlineCameraEffect"));
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
