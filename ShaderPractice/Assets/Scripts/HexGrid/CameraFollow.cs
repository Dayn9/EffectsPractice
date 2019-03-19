using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [SerializeField] private Transform target;
    [SerializeField] private float distanceFromTarget;

    private Vector3 offset;

    // Start is called before the first frame update
    void Start()
    {
        offset = transform.position - target.position;
        offset = offset.normalized * distanceFromTarget;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position = target.position + offset;
    }
}
