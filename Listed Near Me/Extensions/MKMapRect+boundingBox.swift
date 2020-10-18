import MapKit

public typealias Corners = (
    nw: CLLocationCoordinate2D,
    ne: CLLocationCoordinate2D,
    se: CLLocationCoordinate2D,
    sw: CLLocationCoordinate2D
)

extension MKMapRect {
    public var corners: Corners {
        return (
            nw: MKMapPoint(x: self.origin.x, y: self.origin.y).coordinate,
            ne: MKMapPoint(x: self.maxX, y: self.origin.y).coordinate,
            se: MKMapPoint(x: self.maxX, y: self.maxY).coordinate,
            sw: MKMapPoint(x: self.origin.x, y: self.maxY).coordinate
        )
    }
}
