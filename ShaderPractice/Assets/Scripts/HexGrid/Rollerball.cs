using UnityEngine;

//https://unity3d.com/learn/tutorials/projects/roll-ball-tutorial/moving-player?playlist=17141

[RequireComponent(typeof(Rigidbody))]
public class Rollerball : MonoBehaviour
{
    [SerializeField] private float speed;

    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {
        float moveHorizontal = Input.GetAxis("Horizontal");
        float moveVertical = Input.GetAxis("Vertical");

        Vector3 movement = new Vector3(moveHorizontal, 0.0f, moveVertical);

        rb.AddForce(movement * speed);
    }
}
