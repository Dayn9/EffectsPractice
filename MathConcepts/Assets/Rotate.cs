using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField] private float ySpeed;

    // Update is called once per frame
    void FixedUpdate()
    {
        transform.Rotate(Vector3.up, ySpeed * Time.deltaTime);
    }
}
