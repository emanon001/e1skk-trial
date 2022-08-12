module SkkDict exposing (..)

import Dict exposing (Dict)



-- types


type alias SkkDict =
    Dict SkkDictKey SkkDictValues


type alias SkkDictKey =
    String


type alias SkkDictValues =
    List String



-- create


fromDictString : String -> SkkDict
fromDictString dictStr =
    let
        toLines : String -> List String
        toLines =
            String.lines >> List.map String.trim

        filterLines : List String -> List String
        filterLines =
            List.filter (\l -> not (String.startsWith ";" l) && not (String.isEmpty l))

        toEntry : String -> Maybe ( String, List String )
        toEntry l =
            case String.split "/" l of
                _ :: [] ->
                    Nothing

                key :: henkanList ->
                    Just
                        ( String.trim key
                        , List.map (String.split ";" >> List.head) henkanList
                            |> List.map (Maybe.withDefault "")
                            |> List.filter (not << String.isEmpty)
                        )

                _ ->
                    Nothing

        buildDict : List String -> SkkDict
        buildDict lines =
            List.filterMap toEntry lines |> Dict.fromList
    in
    toLines dictStr |> filterLines |> buildDict
