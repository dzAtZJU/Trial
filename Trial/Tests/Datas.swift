//
//  Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation

struct TestDatas {
    static let videoIds = ["M9Uy0opVF3s",
                        "p_rjyLslD0U",
                        "2Gy8eGr7AfM",
                        "VfN3jxENsbc",
                        "beT5Sp6RQ5c",
                        "T0seYxfaoG0",
                        "-2PFeE_sSss",
                        "dDH0EukOeuY",
                        "Em1uK7KKc6o",
                        "ktW5KHxRf4o",
                        "7fBx9Njz4OQ",
                        "9bjjn6tCxfo",
                        "mGxxlX-H7Pc",
                        "3ggfF2oEqrA",
                        "XEYmFOLasn0",
                        "FAWAkaQJLio",
                        "yQNzb9ZZVnw",
                        "HdGEYTyxIoo",
                        "1Sd6dOLMucE",
                        "UeExpFlubTk",
                        "_jePCtHj77Y",
                        "LkHNbsQMxPI",
                        "I9bSGijEDBY",
                        "AL4qa-vNH4U",
                        "OT5eybAoJTo"]
    static let indexPathToVideoId: [IndexPath: VideoId] = {
        var result = [IndexPath: VideoId]()
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                result[IndexPath(row: col, section: row)] = videoIds[row * ytCols + col]
            }
        }
        return result
    }()
}
