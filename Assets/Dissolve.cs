// A script to fade the dissolve/stretch effect in and out

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dissolve : MonoBehaviour
{
    Renderer rend;
    public float dissolveSpeed = 1.9f;
    public float displaceSpeed = 1.0f;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        float dValue = Mathf.PingPong(Time.time * dissolveSpeed, 1.6f) - 0.3f;
        float dsValue = Mathf.PingPong(Time.time * displaceSpeed, 1.6f);
        rend.material.SetFloat("_Amount", dValue);
        rend.material.SetFloat("_Displace", dsValue);
    }
}
