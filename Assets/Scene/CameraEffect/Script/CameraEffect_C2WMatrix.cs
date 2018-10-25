using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraEffect_C2WMatrix : MonoBehaviour {
    private Camera cam;
    
	void Start () {
        cam = GetComponent<Camera>();
	}
    void Update() {
        Shader.SetGlobalMatrix("_Global_CameraEffect_C2WMatrix", cam.cameraToWorldMatrix);
    }
}
