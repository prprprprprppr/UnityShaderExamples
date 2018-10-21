using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RayCastMouse : MonoBehaviour {

    public Camera cam;
    public Material mat;
    public float ScaleSpeed,movespeed;

    private float radius = 1.0f;
    private RaycastHit _hit;
    private Ray _ray;
    private Vector3 curpos;
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            radius += ScaleSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            radius -= ScaleSpeed * Time.deltaTime;
        }
        Mathf.Clamp(radius, 0, 100);
        mat.SetFloat("_Radius", radius);

        Vector3 mousepos = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0);
        _ray = cam.ScreenPointToRay(mousepos);
        if(Physics.Raycast(_ray, out _hit))
        {
            curpos = Vector3.MoveTowards(curpos, _hit.point, movespeed * Time.deltaTime);
            mat.SetVector("_WorldPos",new Vector4(curpos.x,curpos.y,curpos.z,0)); 
        }
    }
}
