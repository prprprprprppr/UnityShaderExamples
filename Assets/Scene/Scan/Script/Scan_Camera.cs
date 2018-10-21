
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scan_Camera : MonoBehaviour {

    public Material mat;
    public GameObject obj;
    
    private float sr;
    private Camera cam;
    private RaycastHit hit;

    private void OnValidate()
    {
        cam = GetComponent<Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;
    }

    // Use this for initialization
    void Start () {
        sr = 0;
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            if(Physics.Raycast(ray,out hit))
            {
                obj.transform.position = hit.point;
                sr = 0;
            }
        }

        mat.SetVector("_WorldOriginPos", obj.transform.position);
        sr += Time.deltaTime*10;
        mat.SetFloat("_WorldRadius", sr);
	}

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
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

        mat.SetMatrix("_RayMatrix", m);

        Graphics.Blit(source, destination, mat);

    }
}
