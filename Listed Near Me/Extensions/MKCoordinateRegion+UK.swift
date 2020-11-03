//
//  MKCoordinateRegion+UK.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 03/11/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    // The centre point of England is around Lindley Hall Farm in Leicestershire
    // 52°33′42.942″N 1°27′53.474″W; SP 36373.66 96143.05
    // 52.561928, -1.464854
    static let England = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.561928, longitude: -1.464854),
        span: MKCoordinateSpan(latitudeDelta: 12, longitudeDelta: 12)
    )
}
