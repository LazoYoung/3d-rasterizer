#ifndef INC_3D_RASTERIZER_FACESET_CUH
#define INC_3D_RASTERIZER_FACESET_CUH


struct FaceSet {
    int count;
    int vertexPerFace;
    size_t arraySize;
    int *indices;
};


#endif //INC_3D_RASTERIZER_FACESET_CUH
