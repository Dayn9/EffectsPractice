﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//https://twitter.com/minionsart/status/1107321893110116352

public class Raised : MonoBehaviour
{
    [SerializeField] private int innerRadius = 5;
    [SerializeField] private float appearSpeed = 5;
    [SerializeField] private Transform target;

    //[SerializeField] private List<MeshRenderer> objects;

    [SerializeField] private List<RaiseObject> objects;
    //private float[] values;

    private MaterialPropertyBlock props;

    public Vector3 Target { get { return target.position; } }

    public RaiseObject AddObject(MeshRenderer obj)
    {
        if (obj == null) { return null; }

        RaiseObject r = new RaiseObject(obj.transform, obj);
        objects.Add(r);
        return r;

    }

    void Start()
    {
        props = new MaterialPropertyBlock();
 
        for (int i = 0; i < objects.Count; i++)
        {
            objects[i].renderer.SetPropertyBlock(props);
        }
    }

    // Update is called once per frame
    void Update()
    {
        for(int i = 0; i< objects.Count; i++)
        {

            if (Vector3.Distance(objects[i].transform.position, target.position) < innerRadius)
            {
                objects[i].value = Mathf.Lerp(objects[i].value, 0, Time.deltaTime * appearSpeed);
            }
            else
            {
                objects[i].value = Mathf.Lerp(objects[i].value, 1, Time.deltaTime * appearSpeed);
            }

            props.SetFloat("_Moved", objects[i].value);
            objects[i].renderer.SetPropertyBlock(props);
        }
    }

    [System.Serializable]
    public class RaiseObject {
        public Transform transform;
        public MeshRenderer renderer;
        public float value;

        public RaiseObject(Transform t, MeshRenderer r, float v = 0)
        {
            transform = t;
            renderer = r;
            value = v;
        }
    }
}
