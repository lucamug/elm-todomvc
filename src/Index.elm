module Index exposing (htmlToReinject, index)

import Html.String exposing (..)
import Html.String.Attributes exposing (..)
import Html.String.Extra exposing (..)
import Main
import Starter.ConfMeta
import Starter.Flags
import Starter.Icon
import Starter.SnippetCss
import Starter.SnippetHtml
import Starter.SnippetJavascript


index : Starter.Flags.Flags -> Html msg
index flags =
    html
        [ lang "en" ]
        [ head []
            ([]
                ++ [ title_ [] [ text Main.conf.title ]
                   , meta [ charset "utf-8" ] []
                   , meta [ name "author", content Main.conf.author ] []
                   , meta [ name "description", content Main.conf.description ] []
                   , meta [ name "viewport", content "width=device-width, initial-scale=1, shrink-to-fit=no" ] []
                   , meta [ httpEquiv "x-ua-compatible", content "ie=edge" ] []
                   , link [ rel "icon", href (Starter.Icon.iconFileName 64) ] []
                   , link [ rel "apple-touch-icon", href (Starter.Icon.iconFileName 152) ] []
                   , link [ rel "stylesheet", href "/base.css" ] []
                   , link [ rel "stylesheet", href "/index.css" ] []
                   , link [ rel "stylesheet", href "/a11y.css" ] []
                   ]
                ++ Starter.SnippetHtml.messagesStyle
                ++ Starter.SnippetHtml.pwa Main.conf
                ++ Starter.SnippetHtml.previewCards Main.conf
            )
        , body []
            ([]
                -- Friendly message in case Javascript is disabled
                ++ (if flags.env == "dev" then
                        Starter.SnippetHtml.messageYouNeedToEnableJavascript

                    else
                        Starter.SnippetHtml.messageEnableJavascriptForBetterExperience
                   )
                -- "Loading..." message
                ++ Starter.SnippetHtml.messageLoading
                -- The DOM node that Elm will take over
                ++ [ div [ id "elm" ] [] ]
                -- Activating the "Loading..." message
                ++ Starter.SnippetHtml.messageLoadingOn
                -- Loading Elm code
                ++ [ script [ src "/elm.js" ] [] ]
                -- Elm finished to load, de-activating the "Loading..." message
                ++ Starter.SnippetHtml.messageLoadingOff
                -- Loading utility for pretty console formatting
                ++ Starter.SnippetHtml.prettyConsoleFormatting flags.env
                -- Signature "Made with ❤ and Elm"
                ++ [ script [] [ textUnescaped Starter.SnippetJavascript.signature ] ]
                -- Paasing metadata to Elm, initializing "window.ElmStarter"
                ++ [ script []
                        [ textUnescaped <|
                            Starter.SnippetJavascript.metaInfo
                                { gitBranch = flags.gitBranch
                                , gitCommit = flags.gitCommit
                                , env = flags.env
                                , version = flags.version
                                }
                        ]
                   ]
                -- Let's start Elm!
                ++ [ Html.String.Extra.script []
                        [ Html.String.textUnescaped
                            """
                            var storedState = localStorage.getItem('elm-todo-save');
                            var startingState = storedState ? JSON.parse(storedState) : null;
                            var node = document.getElementById('elm');
                            window.ElmApp = Elm.Main.init(
                                { node: node
                                , flags: startingState
                                }
                            );
                            // Ports
                            ElmApp.ports.setStorage.subscribe(function(state) {
                                localStorage.setItem('elm-todo-save', JSON.stringify(state));
                            });"""
                        ]
                   ]
                -- Register the Service Worker, we are a PWA!
                ++ [ script [] [ textUnescaped Starter.SnippetJavascript.registerServiceWorker ] ]
            )
        ]


htmlToReinject : a -> List b
htmlToReinject _ =
    []



--
--     , javascriptThatStartsElm = """
-- var storedState = localStorage.getItem('elm-todo-save');
-- var startingState = storedState ? JSON.parse(storedState) : null;
-- var node = document.getElementById('elm');
-- var app = Elm.Main.init(
--     { node: node
--     , flags: startingState
--     }
-- );
-- // Ports
-- app.ports.setStorage.subscribe(function(state) {
--     localStorage.setItem('elm-todo-save', JSON.stringify(state));
-- }); """
--
-- prefix : String
-- prefix =
--     "elm-start-"
--
--
-- tag : { loader : String, notification : String }
-- tag =
--     { notification = prefix ++ "notification"
--     , loader = prefix ++ "loader"
--     }
