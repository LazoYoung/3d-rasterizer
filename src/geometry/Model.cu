#include "Model.cuh"

Model::Model(ModelVertex *vert, ModelFace *face) :
        Geometry(vert->vertices, static_cast<GLsizeiptr>(vert->arraySize), vert->count),
        _vertex(vert), _face(face) {}

void Model::bind() {
    Geometry::bind();

    glGenBuffers(1, &EBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, static_cast<GLsizeiptr>(_face->arraySize), _face->indices,
                 GL_STATIC_DRAW);
}

void Model::draw() {
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, _face->arrayCount, GL_UNSIGNED_INT, nullptr);
    glBindVertexArray(0);
}

Model::~Model() {
    delete[] _vertex->vertices;
    delete[] _face->indices;
    delete _vertex;
    delete _face;
}
