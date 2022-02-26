using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{

    public Rigidbody rb;
    public float forwardForce = 1000f;
    public float sidewardsForce = 20f;

    private bool moveForward = false;
    private bool moveBackward = false;
    private bool moveLeft = false;
    private bool moveRight = false;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update(){
        if(Input.GetKey("w")){
            moveForward = true;
        }else{
            moveForward = false;
        }

        if(Input.GetKey("s")){
            moveBackward = true;
        }else{
            moveBackward = false;
        }

        if(Input.GetKey("a")){
            moveLeft = true;
        }else{
            moveLeft = false;
        }

        if(Input.GetKey("d")){
            moveRight = true;
        }else{
            moveRight = false;
        }
    }

    void FixedUpdate(){
        if(moveForward){
            rb.AddForce(0, 0, forwardForce * Time.deltaTime);
        }
        
        if(moveBackward){
            rb.AddForce(0, 0, -forwardForce * Time.deltaTime);
        }
    
        if(moveLeft){
            rb.AddForce(-sidewardsForce * Time.deltaTime, 0, 0, ForceMode.VelocityChange);
        }

        if(moveRight){
            rb.AddForce(sidewardsForce * Time.deltaTime, 0, 0, ForceMode.VelocityChange);
        }
    }
}
