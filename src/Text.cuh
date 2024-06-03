#ifndef INC_3D_RASTERIZER_TEXT_CUH
#define INC_3D_RASTERIZER_TEXT_CUH


#include "glm/glm.hpp"
#include "glm/ext/matrix_clip_space.hpp"
#include "Window.cuh"
#include "Shader.cuh"
#include <string>
#include <unordered_map>
#include <ft2build.h>
#include FT_FREETYPE_H

using namespace std;
using namespace glm;

class Window;

struct Character {
    GLuint textureId;
    fvec2 size;
    fvec2 bearing;
    FT_Pos advance;
};

enum TextLayout {
    topLeft, topRight, bottomLeft, bottomRight
};

class Text {
public:
    Text() = default;
    ~Text();

    void init(const char *fontPath, Window *window);

    void render(string text, int fontSize, vec3 color, vec2 position, TextLayout layout = bottomLeft);

private:
    const FT_UINT64 _pixelHeight = 48;
    FT_Library _freeType{};
    FT_Face _face{};
    glm::mat4 _projection{};
    GLuint VAO = 0;
    GLuint VBO = 0;
    Window *_window = nullptr;
    Shader *_shader = nullptr;
    std::unordered_map<char, Character> _characters;

    void createCharacter(unsigned char c);

    void setProjection(int width, int height);

    void bind();

    void mapTextPosition(vec2 &pos, TextLayout layout);
};


#endif //INC_3D_RASTERIZER_TEXT_CUH
