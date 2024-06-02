#include "Text.cuh"
#include "glad/glad.h"
#include <stdexcept>

void Text::setProjection(int width, int height) {
    _projection = glm::ortho(0.0f, static_cast<float>(width), 0.0f, static_cast<float>(height));
    _shader->useProgram();
    _shader->setUniformMatrix(glUniformMatrix4fv, "projection", false, _projection);
}

void Text::init(const char *fontPath, Window *window) {
    _shader = new Shader();
    _shader->add("shader/text.vert", GL_VERTEX_SHADER);
    _shader->add("shader/text.frag", GL_FRAGMENT_SHADER);
    _shader->compile();
    _shader->link();

    auto dim = window->getDimension();

    setProjection(dim.x, dim.y);
    window->setResizeCallback([this] (int width, int height) {
        setProjection(width, height);
    });

    if (FT_Init_FreeType(&_freeType)) {
        throw std::runtime_error("Could not init FreeType Library!");
    }

    if (FT_New_Face(_freeType, fontPath, 0, &_face)) {
        throw std::runtime_error("Failed to load font!");
    }

    FT_Set_Pixel_Sizes(_face, 0, _pixelHeight);

    if (FT_Load_Char(_face, 'X', FT_LOAD_RENDER)) {
        throw std::runtime_error("Failed to load Glyph!");
    }

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); // disable byte-alignment restriction

    for (unsigned char c = 0; c < 128; c++) {
        createCharacter(c);
    }

    FT_Done_Face(_face);
    FT_Done_FreeType(_freeType);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    bind();
}

void Text::render(string text, float x, float y, int fontSize, vec3 color)
{
    if (!_shader) {
        throw runtime_error("Shader is null!");
    }

    _shader->useProgram();
    _shader->setUniform("textColor", color.x, color.y, color.z);
    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(VAO);

    float scale = static_cast<float>(fontSize) / static_cast<float>(_pixelHeight);

    for (auto c = text.begin(); c != text.end(); c++)
    {
        Character ch = _characters[*c];

        float xPos = x + ch.bearing.x * scale;
        float yPos = y - (ch.size.y - ch.bearing.y) * scale;

        float w = ch.size.x * scale;
        float h = ch.size.y * scale;
        float vertices[6][4] = {
                {xPos,     yPos + h, 0.0f, 0.0f },
                {xPos,     yPos,     0.0f, 1.0f },
                {xPos + w, yPos,     1.0f, 1.0f },

                {xPos,     yPos + h, 0.0f, 0.0f },
                {xPos + w, yPos,     1.0f, 1.0f },
                {xPos + w, yPos + h, 1.0f, 0.0f }
        };
        // Render glyph texture over quad
        glBindTexture(GL_TEXTURE_2D, ch.textureId);
        // Update content of VBO memory
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        // Render quad
        glDrawArrays(GL_TRIANGLES, 0, 6);

        // Advance cursors for next glyph
        // Bitshift by 6 to get value in pixels (2^6 = 64)
        x += static_cast<float>(ch.advance >> 6) * scale;
    }
    glBindVertexArray(0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

void Text::bind() {
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glBindVertexArray(VAO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * 6 * 4, nullptr, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(float), nullptr);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}

void Text::createCharacter(unsigned char c) {
    if (FT_Load_Char(_face, c, FT_LOAD_RENDER)) {
        throw std::runtime_error("Failed to load Glyph!");
    }

    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(
            GL_TEXTURE_2D,
            0,
            GL_RED,
            static_cast<GLsizei>(_face->glyph->bitmap.width),
            static_cast<GLsizei>(_face->glyph->bitmap.rows),
            0,
            GL_RED,
            GL_UNSIGNED_BYTE,
            _face->glyph->bitmap.buffer
    );
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    Character character = {
            texture,
            glm::fvec2(_face->glyph->bitmap.width, _face->glyph->bitmap.rows),
            glm::fvec2(_face->glyph->bitmap_left, _face->glyph->bitmap_top),
            _face->glyph->advance.x
    };

    _characters.insert(std::pair<char, Character>(c, character));
}

Text::~Text() {
    if (_shader) {
        free(_shader);
    }
}
