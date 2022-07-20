//
//  RESTFulConstant.swift
//  FavoriteList
//
//  Created by Justin Haung on 2022/7/20.
//

import Foundation

private let v4 = "/v4"

private let domain = URL(string: "https://api.jikan.moe")!

private let getTopMangaListPath = "/top/manga"
private let getTopAnimeListPath = "/top/anime"

let getTopMangaListApi: URL = domain.appendingPathComponent(v4).appendingPathComponent(getTopMangaListPath)
let getTopAnimeListApi: URL = domain.appendingPathComponent(v4).appendingPathComponent(getTopAnimeListPath)
