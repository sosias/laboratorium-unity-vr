using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cameraFollow : MonoBehaviour
{

    public Transform player;
    private Vector3 offset;

    // Start is called before the first frame update
    void Start()
    {
        offset = new Vector3(0,1,-8);
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position = player.position + offset;
    }
}
