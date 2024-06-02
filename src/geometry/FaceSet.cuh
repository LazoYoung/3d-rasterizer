#ifndef INC_3D_RASTERIZER_FACESET_CUH
#define INC_3D_RASTERIZER_FACESET_CUH


struct FaceSet {
    int count;
    int vertexPerFace;
    int arrayCount;
    size_t arraySize;
    GLuint *indices;
};


#endif //INC_3D_RASTERIZER_FACESET_CUH
