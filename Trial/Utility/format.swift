//
//  format.swift
//  Trial
//
//  Created by 周巍然 on 2019/6/11.
//  Copyright © 2019 周巍然. All rights reserved.
//

import Foundation

extension String {
    func stripZeroHour() -> String {
        guard self.hasPrefix("0:") else { return self }
        return String(self.dropFirst(2))
    }
}
