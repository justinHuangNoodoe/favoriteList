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

let getTopMangaListApi: URL = domain.appendingPathComponent(v4).appendingPathComponent(getTopMangaListPath)
