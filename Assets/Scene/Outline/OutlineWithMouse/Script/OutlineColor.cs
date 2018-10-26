using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutlineColor : MonoBehaviour {

    public Color col;
    [HideInInspector]
    public Color curColor;
    public float speed = 1.0f;
    
    private Color tarColor;

    // Use this for initialization
    void Start () {
        SetOutline.RegisterOutlineObject(this);
        tarColor = Color.black;
    }
	
	// Update is called once per frame
	void Update () {
        curColor = Color.Lerp(curColor, tarColor, Time.deltaTime * speed);
	}

    private void OnMouseEnter()
    {
        tarColor = col;
    }

    private void OnMouseExit()
    {
        tarColor = Color.black;
    }
}
