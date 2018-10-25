using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum CameraDepth
{
    Depth,
    DepthNormals
};

[ExecuteInEditMode]
public class CameraEffect_Depth : MonoBehaviour {

    public CameraDepth _camdepth;

    private Camera cam;

	// Use this for initialization
	void Start () {
        cam = GetComponent<Camera>();
        switch (_camdepth)
        {
            case CameraDepth.Depth:
                cam.depthTextureMode = DepthTextureMode.Depth;
                break;
            case CameraDepth.DepthNormals:
                cam.depthTextureMode = DepthTextureMode.DepthNormals;
                break;
            default:break;
        }
	}
}
