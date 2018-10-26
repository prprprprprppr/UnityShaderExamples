using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class SetOutline : MonoBehaviour {
    private static SetOutline _instance;

    public int intensity = 3;
    public float blurSize = 1.0f;

    private CommandBuffer _commandBuffer;
    private Material mat;
    private Material mat2;
    private int preRenderTextureID;
    private int blurRenderTextureID;
    private int TempRenderTextureID;
    private List<OutlineColor> objs = new List<OutlineColor>();
    private Camera cam;

    // Use this for initialization
    void Awake ()
    {
        _instance = this;

        _commandBuffer = new CommandBuffer();
        _commandBuffer.name = "Outline";
        cam = GetComponent<Camera>();
        cam.AddCommandBuffer(CameraEvent.BeforeImageEffectsOpaque, _commandBuffer);
        mat = new Material(Shader.Find("Hidden/Outline"));
        mat2 = new Material(Shader.Find("Hidden/OutlineBlur"));
        preRenderTextureID = Shader.PropertyToID("_GlowPrePassTex");
        blurRenderTextureID = Shader.PropertyToID("_GlowBlurredTex");
        TempRenderTextureID = Shader.PropertyToID("TempTex");
    }

    public static void RegisterOutlineObject(OutlineColor obj)
    {
        if(_instance != null)
        {
            _instance.objs.Add(obj);
        }
    }

    // Update is called once per frame
    void Update()
    {
        _commandBuffer.Clear();
        _commandBuffer.GetTemporaryRT(preRenderTextureID, -1, -1, 0, FilterMode.Bilinear);
        _commandBuffer.SetRenderTarget(preRenderTextureID);
        _commandBuffer.ClearRenderTarget(true, true, Color.clear);

        for (int i = 0; i < objs.Count; i++)
        {
            _commandBuffer.SetGlobalColor("_GlobalOutlineColor", objs[i].curColor);
            _commandBuffer.DrawRenderer(objs[i].GetComponentInChildren<Renderer>(), mat);
        }

        _commandBuffer.GetTemporaryRT(blurRenderTextureID, -2, -2, 0, FilterMode.Bilinear);
        _commandBuffer.GetTemporaryRT(TempRenderTextureID, -2, -2, 0, FilterMode.Bilinear);


        _commandBuffer.Blit(preRenderTextureID, blurRenderTextureID);
        mat2.SetFloat("_BlurSize", blurSize);
        for(int i=0;i< intensity; i++)
        {
            _commandBuffer.Blit(blurRenderTextureID, TempRenderTextureID, mat2, 0);
            _commandBuffer.Blit(TempRenderTextureID, blurRenderTextureID, mat2, 1);
        }

        _commandBuffer.ReleaseTemporaryRT(preRenderTextureID);
        _commandBuffer.ReleaseTemporaryRT(blurRenderTextureID);
        _commandBuffer.ReleaseTemporaryRT(TempRenderTextureID);
    }
}
