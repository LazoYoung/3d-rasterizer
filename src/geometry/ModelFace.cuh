#ifndef INC_3D_RASTERIZER_MODELFACE_CUH
#define INC_3D_RASTERIZER_MODELFACE_CUH


struct ModelFace {
    int count;
    int vertexPerFace;
    int arrayCount;
    size_t arraySize;
    GLuint *indices;
};


#endif //INC_3D_RASTERIZER_MODELFACE_CUH
