{-
    Вспомогательный модуль.
    https://github.com/denisshevchenko/ruhaskell
    Все права принадлежат русскоязычному сообществу Haskell-разработчиков, 2015 г.
-}

{-# LANGUAGE OverloadedStrings #-}

module Misc (
    aHost,
    prepareAllTemplates,
    getNameOfAuthor,
    TagsAndAuthors,
    TagsReader,
    getRussianNameOfCategory
) where

import Control.Monad.Reader
import qualified Data.Map as M
import Hakyll

-- Данный URL останется актуальным до тех пор, пока сайт будет жить на GitHub Pages.
aHost :: String
aHost = "http://ruhaskell.org"

-- Готовим все шаблоны из каталога templates.
prepareAllTemplates :: Rules ()
prepareAllTemplates = match "templates/*" $ compile templateCompiler

-- Читательское "облако" с тематическими тегами, категориями и именами авторов статей.
type TagsAndAuthors = [Tags]
type TagsReader = ReaderT TagsAndAuthors Rules ()

-- Извлекает из статьи значение атрибута `author`.
getNameOfAuthor :: MonadMetadata m => Identifier -> m [String]
getNameOfAuthor identifier = do
    -- Собираем атрибуты статьи в обычный ассоциативный контейнер.
    metadata <- getMetadata identifier
    let author = M.findWithDefault "Не указан" "author" metadata
    return [trim author]

-- Имена категорий извлекаются из файлового пути, поэтому они всегда английские.
-- Это не красиво, поэтому мы формируем словарь русских имён для категорий.
russianNamesOfCategories :: M.Map String String
russianNamesOfCategories = M.fromList[ ("web",      "Веб")
                                     , ("tasks",    "Задачи")
                                     , ("projects", "Проекты")
                                     , ("utils",    "Утилиты")
                                     , ("theory",   "Теория")
                                     , ("dynamic",  "Динамика")
                                     , ("packages", "Пакеты")
                                     , ("elm",      "Elm")
                                     , ("frp",      "FRP")
                                     , ("gui",      "GUI")
                                     , ("typesystem", "Система типов")
                                     ]

getRussianNameOfCategory :: String -> String
getRussianNameOfCategory englishName = M.findWithDefault englishName englishName russianNamesOfCategories
