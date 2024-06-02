#ifndef INC_3D_RASTERIZER_VERTEXSET_CUH
#define INC_3D_RASTERIZER_VERTEXSET_CUH


#include <string>

struct VertexSet {
    vector<std::string> keys;
    unordered_map<std::string, int> keyIndex;
    int count;
    int arrayCount;
    size_t arraySize;
    GLfloat *vertices;
};


#endif //INC_3D_RASTERIZER_VERTEXSET_CUH
