using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ModelMeshMaxMinPos : MonoBehaviour {

    public Material mat;

	// Use this for initialization
	void Start () {
        Vector3[] verts = GetComponent<SkinnedMeshRenderer>().sharedMesh.vertices;
        int val = GetComponent<SkinnedMeshRenderer>().sharedMesh.vertexCount;
        Vector3 top = new Vector3(0,float.MinValue,0);
        Vector3 bottom = new Vector3(0, float.MaxValue, 0);
        for (int i=0;i < val; i++)
        {
            Vector3 temp = transform.TransformPoint(verts[i]);
            if (temp.y > top.y)
            {
                top = temp;
            }
            if (temp.y < bottom.y)
            {
                bottom = temp;
            }
        }
        mat.SetVector("_ModelTop", top);
        mat.SetVector("_ModelBottom", bottom);

    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
