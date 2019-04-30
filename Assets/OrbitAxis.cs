// A script to make the light source rotate around a given axis.

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrbitAxis : MonoBehaviour
{
    public enum Axis 
    {
        X, Y, Z
    };

    public Vector3 point;
    public Axis axisC;    // Axis that is chosen in the Inspector dropdown
    private Vector3 axis; // Translation of dropdown axis to Vector3

    [Range(-100.0f, 100)] public float rotationSpeed = 20;

    // Start is called before the first frame update
    void Start()
    {
        if (axisC == Axis.X) {
            axis = new Vector3(1, 0, 0);
        } else if (axisC == Axis.Y) {
            axis = new Vector3(0, 1, 0);
        } else if (axisC == Axis.Z) {
            axis = new Vector3(0, 0, 1);
        }
    }

    // Update is called once per frame
    void Update()
    {
        transform.RotateAround(point, axis, rotationSpeed * Time.deltaTime);
    }
}
