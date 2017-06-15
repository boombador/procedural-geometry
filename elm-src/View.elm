module View exposing (view)

import Models exposing (Model)
import Html exposing (Html, div)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import WebGL exposing (Mesh, Shader)
import Procedural.Main exposing (sampleTriangles)
import Procedural.Models exposing (Vertex)


view : Model -> Html msg
view { currentTime } =
    div []
        [ WebGL.toHtml
            [ width 400
            , height 400
            , style [ ( "display", "block" ) ]
            ]
            [ WebGL.entity
                vertexShader
                fragmentShader
                mesh
                { perspective = perspective (currentTime / 1000) }
            ]
        ]


mesh : Mesh Vertex
mesh =
    WebGL.triangles sampleTriangles


target : Vec3
target =
    vec3 0 0 0


eyeHeight : Float
eyeHeight =
    1


perspective : Float -> Mat4
perspective t =
    Mat4.mul
        (Mat4.makePerspective 45 1 0.01 100)
        (Mat4.makeLookAt (vec3 (4 * cos t) eyeHeight (4 * sin t)) target (vec3 0 1 0))



-- Shaders


type alias Uniforms =
    { perspective : Mat4 }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        varying vec3 vcolor;
        void main () {
            gl_Position = perspective * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        varying vec3 vcolor;
        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }
    |]
