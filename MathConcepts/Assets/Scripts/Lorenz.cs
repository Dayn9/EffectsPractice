using UnityEngine;

public class Lorenz : MonoBehaviour
{
    private float a = 10;
    private float b = 28;
    private float c = 8.0f / 3.0f;

    void FixedUpdate()
    {
        Vector3 pos = transform.position;
        transform.position = pos + new Vector3(a * ( pos.y - pos.x ),
                                         pos.x * ( b - pos.z) - pos.y,
                                         pos.x * pos.y - c * pos.z) * 0.01f;
    }
}
