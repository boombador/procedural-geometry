port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import String


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }


-- MODEL

type alias Model =
  { word : String
  , suggestions : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], check "testspelling")


-- UPDATE

type Msg
  = Change String
  | Check
  | Suggest (List String)


port check : String -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newWord ->
      ( Model newWord [], Cmd.none )

    Check ->
      ( model, check model.word )

    Suggest newSuggestions ->
      ( Model model.word newSuggestions, Cmd.none )


-- SUBSCRIPTIONS

port suggestions : (List String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  suggestions Suggest


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ onInput Change ] []
    , button [ onClick Check ] [ text "Check" ]
    , div [] [ text (String.join ", " model.suggestions) ]
    ]

