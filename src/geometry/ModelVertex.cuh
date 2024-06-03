#ifndef INC_3D_RASTERIZER_MODELVERTEX_CUH
#define INC_3D_RASTERIZER_MODELVERTEX_CUH


#include <string>

struct ModelVertex {
    vector<std::string> keys;
    unordered_map<std::string, int> keyIndex;
    int count;
    int arrayCount;
    size_t arraySize;
    GLfloat *vertices;
    bool hasNormals;
};


#endif //INC_3D_RASTERIZER_MODELVERTEX_CUH
