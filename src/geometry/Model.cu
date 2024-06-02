#include "Model.cuh"

Model::Model(VertexSet *vert, FaceSet *face) :
        Geometry(vert->vertices, static_cast<GLsizeiptr>(vert->arraySize)),
        _vertexSet(vert), _faceSet(face) {}

void Model::bind() {
    Geometry::bind();

    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, static_cast<GLsizeiptr>(_faceSet->arraySize), _faceSet->indices,
                 GL_STATIC_DRAW);
}

void Model::draw() {
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, _faceSet->arrayCount, GL_UNSIGNED_INT, nullptr);
    glBindVertexArray(0);
}

Model::~Model() {
    delete[] _vertexSet->vertices;
    delete[] _faceSet->indices;
    delete _vertexSet;
    delete _faceSet;
}
