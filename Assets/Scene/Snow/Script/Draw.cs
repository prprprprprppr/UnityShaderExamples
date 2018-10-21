using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Draw : MonoBehaviour {
    
    public Shader DrawShader;
    [Range(0,500)]
    public float smooth;
    public GameObject charactor;

    private Material Snowmat;
    private Material Drawmat;
    private RenderTexture tex;
    private RaycastHit hit;

    void Start ()
    {
        Snowmat = GetComponent<MeshRenderer>().material;
        Drawmat = new Material(DrawShader);

        Drawmat.SetVector("_Color", Color.red);
        Drawmat.SetFloat("_Smooth", smooth);
        tex = new RenderTexture(500, 500, 0, RenderTextureFormat.ARGBFloat);
        Snowmat.SetTexture("_TraceTex", tex);
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (Physics.Raycast(charactor.transform.position,-Vector3.up, out hit))
        { 
            Drawmat.SetVector("_Coord", new Vector4(hit.textureCoord.x, hit.textureCoord.y, 0, 0));
            RenderTexture temp = RenderTexture.GetTemporary(tex.width, tex.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(tex, temp);
            Graphics.Blit(temp, tex, Drawmat);
            RenderTexture.ReleaseTemporary(temp);
        }



    }
}
