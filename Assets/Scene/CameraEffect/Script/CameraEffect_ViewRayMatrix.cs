using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraEffect_ViewRayMatrix : MonoBehaviour {
    
    private Camera cam;
    
	void Start () {
        cam = GetComponent<Camera>();
	}

    void Update() {
        float fov = cam.fieldOfView;//竖直方向视场角
        float near = cam.nearClipPlane;
        float far = cam.farClipPlane;
        float aspect = cam.aspect;//纵横比

        float halfHeight = Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
        Vector3 toRight = cam.transform.right * halfHeight * aspect;
        Vector3 toUp = cam.transform.up * halfHeight;

        Vector3 topLeft = cam.transform.forward + toUp - toRight;
        float scale = topLeft.magnitude * far;
        topLeft.Normalize();
        topLeft *= scale;

        Vector3 topRigt = cam.transform.forward + toUp + toRight;
        scale = topRigt.magnitude * far;
        topRigt.Normalize();
        topRigt *= scale;

        Vector3 downLeft = cam.transform.forward - toUp - toRight;
        scale = downLeft.magnitude * far;
        downLeft.Normalize();
        downLeft *= scale;

        Vector3 downRight = cam.transform.forward - toUp + toRight;
        scale = downRight.magnitude * far;
        downRight.Normalize();
        downRight *= scale;

        Matrix4x4 m = new Matrix4x4();
        m.SetRow(0, downLeft);
        m.SetRow(1, downRight);
        m.SetRow(2, topLeft);
        m.SetRow(3, topRigt);

        Shader.SetGlobalMatrix("_Global_CameraEffect_ViewRayMatrix", m);
    }
}
