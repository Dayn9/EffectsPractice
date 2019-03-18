using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnHexGrid : MonoBehaviour
{
    [SerializeField] private GameObject hex;
    [SerializeField] private float radius;
    [SerializeField] private int gridSize;

    private Vector3 axisOne;
    private Vector3 axisTwo;

    private Vector3 origin;

    private Raised raised;

    private void Awake()
    {
        raised = GetComponent<Raised>();

        float axisLength = radius * Mathf.Sqrt(3);

        axisOne = new Vector3(0, 0, axisLength);
        axisTwo = new Vector3(axisLength * Mathf.Sqrt(3) / 2, 0, -axisLength / 2);
        axisTwo = new Vector3(axisLength * Mathf.Sqrt(3) / 2, 0, -axisLength / 2);

        origin = Vector3.zero;

        for(int a1 = -gridSize; a1 <= gridSize; a1++)
        {
            for (int a2 = -gridSize; a2 <= gridSize; a2++)
            {
                if (Mathf.Abs(a1) + Mathf.Abs(a2) > gridSize && Mathf.Sign(a1) != Mathf.Sign(a2)) continue;
                    
                raised.AddObject(InstantiateOnHex(a1, a2).GetComponent<MeshRenderer>());
            }
        }
    }

    private GameObject InstantiateOnHex(int a1, int a2)
    {
        Vector3 position = origin + (a1 * axisOne) + (a2 * axisTwo);
        return Instantiate(hex, position, Quaternion.identity);
    }


}
