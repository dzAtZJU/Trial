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
    
    static let episodesIds = [["QRTilgi6uyY","kDeGSF4-LJQ","12OgFyZrvSA","2fnXinRYZfM","iV-NodOe1So","Vklv3aKo6kU"],
                              ["l-KKL3JoBn4","PcTSkRu4Otk","VixRguWdOVM","58-7YRMOHew","F0owic6UgIU"],
                              ["RmFNdViNBWk","YVzY8wvM-XU","aTZxAecgQDE","RT9CbVK6XN8","Mccbjk_I_q0"],
                              ["3iuoSkC0B80","XUYr0aZDpcY","A8guig4UlYI","UFl4iuUaMMw"],
                              ["JfOVmikf_fw","2v1nelJ0pzo","U2wrW4uMhxA","JaYv2jRSBgk"]]
    
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
