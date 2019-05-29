//
//  Data.swift
//  Trial
//
//  Created by 周巍然 on 2019/3/28.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation

struct TestDatas {
    static let videoIds = ["876pLueclwE", //
                        "YASCaIdh2HE", //
                        "YZxmoOvqWek", //
                        "3F04f64yV2w", //
                        "aSjflT_J0Xo", //
                        "UzjMPWAqShY",
                        "EfVdMsZCEUg",
                        "O3Z_LKxPJXQ",
                        "12OgFyZrvSA",
                        "L928fBrLDwg",
                        "v06MtToMbNE",
                        "YpB0MRlip1c",
                        "b-D8Es87fkU",
                        "kHUDonhF7_I",
                        "ox6u7gv3tIk",
                        "l-KKL3JoBn4",
                        "uNacesqyKTI",
                        "_Qd4bL19dLM",
                        "JTrNa7FV0O4",
                        "tcqjwadyVYw",
                        "QOHa6FBUdsQ",
                        "aan9vCi2oi8",
                        "IF8BEEQSzfw",
                        "Yz0lAvzM5S4",
                        "luPp3CP784g"]
    
    
    
    static let indexPathToVideoId: [IndexPath: VideoId] = {
        assert(Set(videoIds).count == videoIds.count)
        var result = [IndexPath: VideoId]()
        for row in 0..<ytRows {
            for col in 0..<ytCols {
                result[IndexPath(row: col, section: row)] = videoIds[row * ytCols + col]
            }
        }
        return result
    }()
}

let TestState = 2 // 无阴影
