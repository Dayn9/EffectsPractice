using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Raised))]
public class SpawnHexGrid : MonoBehaviour
{
    /// <summary>
    /// controls the spawning of the hex grid
    /// </summary>

    [SerializeField] private GameObject hex; //hexagon object prefab
    [SerializeField] private float radius; //manual input radius of hex prefab
    [SerializeField] private int gridSize; //number oh hexagon rings around orgin to create

    private Vector3 axisOne; //axis one for the hex grid 
    private Vector3 axisTwo; //axis two for the hex grid

    private Vector3 origin = Vector3.zero; //center of the grid

    private Raised raised; //ref to raised component

    private void Awake()
    {
        //get a reference to the Raised script
        raised = GetComponent<Raised>();

        //create the axis
        float axisLength = radius * Mathf.Sqrt(3);
        axisOne = new Vector3(0, 0, axisLength);
        axisTwo = new Vector3(axisLength * Mathf.Sqrt(3) / 2, 0, -axisLength / 2);

        //create the hex grid
        for(int a1 = -gridSize; a1 <= gridSize; a1++)
        {
            for (int a2 = -gridSize; a2 <= gridSize; a2++)
            {
                //skip tiles that are ouside the hexagon grid
                if (Mathf.Abs(a1) + Mathf.Abs(a2) > gridSize && Mathf.Sign(a1) != Mathf.Sign(a2)) continue;
                
                //create object and add object to the raised list
                raised.AddObject(InstantiateOnHex(a1, a2).GetComponent<MeshRenderer>());
            }
        }
        Debug.Log(WorldToHex(axisTwo));
    }

    /// <summary>
    /// Instantiate the hex object on the hex grid
    /// </summary>
    /// <param name="a1">position on axis One</param>
    /// <param name="a2">position on axis Two</param>
    /// <returns>Instantiated Object</returns>
    private GameObject InstantiateOnHex(int a1, int a2)
    {
        Vector3 position = origin + (a1 * axisOne) + (a2 * axisTwo);
        return Instantiate(hex, position, Quaternion.identity);
    }

    /// <summary>
    /// Converts the World space coordinates oon to hex coordinates
    /// </summary>
    /// <param name="position">World space position</param>
    /// <returns>Hex grid (a1,a2) position</returns>
    public Vector2 WorldToHex(Vector3 position)
    {
        position -= origin;
        return WorldToHex(new Vector2(position.x, position.z));
    }

    /// <summary>
    /// Converts the World space coordinates oon to hex coordinates
    /// </summary>
    /// <param name="position">World space (X,Z) position</param>
    /// <returns>Hex grid (a1,a2) position</returns>
    private Vector2 WorldToHex(Vector2 position)
    {
        // 1 - Create an empty Vector
        Vector2 hex = Vector2.zero; 

        // 2 - Convert the axis to XZ Vector2
        Vector2 a1 = new Vector2(axisOne.x, axisOne.z);
        Vector2 a2 = new Vector2(axisTwo.x, axisTwo.z);

        // 3 - Find the Projection of world space vector onto axis 
        Vector2 projA1 = Proj(position, a1);
        Vector2 projA2 = Proj(position, a2);

        // 4 -  Convert to Hex coordinates
        hex.x = projA1.magnitude / axisOne.magnitude;
        hex.y = projA2.magnitude / axisTwo.magnitude;

        // 5 - Make sure hex values have the correct sign
        hex.x *= Mathf.Sign(Vector2.Dot(position, a1));
        hex.y *= Mathf.Sign(Vector2.Dot(position, a2));

        // 6 - return converted hex position
        return hex;
    }

    /// <summary>
    /// get projection of one vector onto another
    /// </summary>
    /// <param name="v1">origional vector</param>
    /// <param name="v2">vector projecting onto</param>
    /// <returns></returns>
    private Vector2 Proj(Vector2 v1, Vector2 v2)
    {
        return (Vector2.Dot(v1, v2) / Mathf.Pow(v2.magnitude, 2)) * v2; //projection formula
    }

    /// <summary>
    /// rotate vector 90 degrees
    /// </summary>
    /// <param name="normal">origional vector</param>
    /// <returns>orthogonal vector</returns>
    private Vector2 Tangent(Vector2 normal)
    {
        return new Vector2(normal.y, -normal.x); //apply and return rotation
    }
}