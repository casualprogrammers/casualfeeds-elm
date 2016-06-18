import Html exposing (..)
import Html.App as Html
import Http
import Json.Decode as Json exposing (..)
import Task exposing (Task)


-- initialisation
main: Program Never
main =
  Html.program
    { init = init "Casual feed" [RedditData "" "Loading"]
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { title : String
  , feeds: List RedditData
  }

type alias RedditThing = 
  { kind: String
  , data: RedditData
  }

type alias RedditData =
  { thumbnail: String
  , permalink: String
  }

init : String -> List RedditData-> (Model, Cmd Msg)
init title feeds =
  ( Model title feeds
  , getFeed "https://www.reddit.com/r/all.json"
  )



-- UPDATE


type Msg
  = FetchSucceed (List RedditData)
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchSucceed  feeds ->
      (Model model.title feeds, Cmd.none)

    FetchFail _ ->
      (Model "fail" model.feeds, Cmd.none)



-- VIEW
listItem : RedditData -> Html msg
listItem data = li [] [text data.permalink]

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.title]
    , br [] []
    , p [] (List.map (listItem) model.feeds)
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getFeed : String -> Cmd Msg
getFeed url = 
  Http.get decodeResponse url
  |> Task.perform FetchFail FetchSucceed 


-- decoders

decodeThing: Json.Decoder RedditData
decodeThing = Json.at ["data"] (decodeData)

decodeData: Json.Decoder RedditData
decodeData =   
      Json.object2 RedditData
    ("thumbnail" := Json.string) 
    ("permalink" := Json.string)


decodeResponse : Json.Decoder (List RedditData)
decodeResponse =  Json.at ["data", "children"] (Json.list decodeThing)
