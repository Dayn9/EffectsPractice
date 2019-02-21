using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum CameraType { Perspective, Orthographic, Default}

public class CameraTransformation : Transformation
{
    [SerializeField] private float focalLength = 1f;
    [SerializeField] private CameraType camType;

    public override Matrix4x4 Matrix
    {
        get
        {
            Matrix4x4 matrix = new Matrix4x4();
            switch (camType)
            {
                case CameraType.Perspective:
                    matrix.SetRow(0, new Vector4(focalLength, 0f, 0f, 0f));
                    matrix.SetRow(1, new Vector4(0f, focalLength, 0f, 0f));
                    matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
                    matrix.SetRow(3, new Vector4(0f, 0f, 1f, 0f));
                    break;
                case CameraType.Orthographic:
                    matrix.SetRow(0, new Vector4(1f, 0f, 0f, 0f));
                    matrix.SetRow(1, new Vector4(0f, 1f, 0f, 0f));
                    matrix.SetRow(2, new Vector4(0f, 0f, 0f, 0f));
                    matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));
                    break;
                case CameraType.Default:
                default:
                    matrix.SetRow(0, new Vector4(1f, 0f, 0f, 0f));
                    matrix.SetRow(1, new Vector4(0f, 1f, 0f, 0f));
                    matrix.SetRow(2, new Vector4(0f, 0f, 1f, 0f));
                    matrix.SetRow(3, new Vector4(0f, 0f, 0f, 1f));
                    break;
            }
            return matrix;
        }
    }
}
