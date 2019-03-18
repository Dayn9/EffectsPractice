﻿using UnityEngine;

//https://twitter.com/minionsart/status/1107321893110116352

public class Raised : MonoBehaviour
{
    [SerializeField] private int radius = 5;
    [SerializeField] private float appearSpeed = 5;
    [SerializeField] private Transform target;

    [SerializeField] private MeshRenderer[] objects;
    public float[] values;

    MaterialPropertyBlock props;


    void Awake()
    {
        props = new MaterialPropertyBlock();
        values = new float[objects.Length];
        for (int i = 0; i < objects.Length; i++)
        {
            objects[i].SetPropertyBlock(props);
        }
    }

    // Update is called once per frame
    void Update()
    {
        for(int i = 0; i< objects.Length; i++)
        {
            if (Vector3.Distance(objects[i].transform.position, target.position) < radius)
            {
                values[i] = Mathf.Lerp(values[i], 0, Time.deltaTime * appearSpeed);
            }
            else
            {
                values[i] = Mathf.Lerp(values[i], 1, Time.deltaTime * appearSpeed);
            }
            props.SetFloat("_Moved", values[i]);
            objects[i].SetPropertyBlock(props);
        }

        
    }
}
