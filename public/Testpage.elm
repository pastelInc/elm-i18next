module Testpage exposing (..)

import Html exposing (Html, div, program, text)
import I18Next
    exposing
        ( Delims(..)
        , Translations
        , t
        , tr
        )


type Msg
    = UpdateTranslations I18Next.Msg


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { translations : Translations
    }


init : ( Model, Cmd Msg )
init =
    let
        ( translations, cmd ) =
            I18Next.loadingTranslations "en"
    in
    ( Model translations, Cmd.map UpdateTranslations cmd )


view : Model -> Html msg
view model =
    div
        []
        [ div [] [ text ("Some model " ++ toString model) ]
        , div [] [ text ("t \"a\" = " ++ t model.translations "a") ]
        , div [] [ text ("t \"b.c\" = " ++ t model.translations "b.c") ]
        , div [] [ text ("t \"b.d\" = " ++ t model.translations "b.d") ]
        , div []
            [ text
                ("tr ( \"{{ \", \"}}\" ) \"b.e.f\" [ ( \"firstname\", \"Peter\" ), ( \"lastname\", \"Lustig\" ) ]= "
                    ++ tr model.translations Curly "b.e.f" [ ( "firstname", "Peter" ), ( "lastname", "Lustig" ) ]
                )
            ]
        , div [] [ text ("t \"notExisting\" = " ++ t model.translations "notExisting") ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTranslations subMsg ->
            let
                translations =
                    I18Next.update subMsg model.translations
            in
            ( { model | translations = translations }, Cmd.none )
