# GeospatialKit

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 4](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)

What is GeospatialKit?

GeospatialKit is an interface to translate a GeoJson document / dictionary into a swift object which fully conforms to the latest [GeoJson specification - August 2016](https://tools.ietf.org/html/rfc7946).

A GeoJsonObject can be transformed to a bounding box, be projected as an image, or zoomed and rendered to a map.

## Features

* Fully unit tested - 92+% coverage
* Ongoing development

### Geospatial Example

* An Example application which supplies the most common use cases of GeoJson
* Parses all use cases into GeoJsonObjects and displays the options in a table view

## Geospatial

Geospatial

* The main interface consisting of 4 sub interface

### GeoJson

Geospatial.geoJson

* Full GeoJson specification support to create a GeoJsonObject
* A GeoJsonObject is the base object of GeospatialKit functionality
* Bounding Box generated from any GeoJsonObject
* GeoJson generated from any GeoJsonObject

### GeoJsonObjects

* Minimum distance to a given point (Optional error distance)
* Bounding Box
* GeoJson as a Dictionary
* Contains a given point (Optional Error Distance)
* Points making up the shape
* All objects are equatable

* Point
  * Normalize
  * Bearing to a given point
  * Midpoint to a given point
* MultiPoint
  * Centroid
* LineString
  * Centroid
  * Length
* MultiLineString
  * Centroid
* Polygon
  * Centroid
  * Area
* MultiPolygon
  * Centroid
* GeometryCollection
* Feature
* FeatureCollection


### Geohash

Geospatial.geohash

* Find the geohash of any coordinate
* Find the center coordinate of any geohash
* Find all 9 neighboring geohash given a coordinate
* Create a bounding box (GeohashBox) from a geohash

### Mapping

Geospatial.map

* Simple API to assist in displaying a GeoJsonObject on a map
* Easily zoom in on the GeoJsonObject by setting the region to geoJsonObject.boundingBox.region
* Generate overlays and annotations from any GeoJsonObject
* Generate an overlay renderer from any overlay created by the API
* Displays rendered zoomed overlays and annotations on a map view.

### Imaging

Geospatial.image

* Create an image from any GeoJsonObject using point projection
* Displays an image view as created from a GeoJsonObect

### WKT - Not Fully Supported

Geospatial.parse(wkt: String) -> GeoJsonObject

* Minimal WKT parsing support which transforms to a GeoJsonObject.
* POINT, LINESTRING, MULTILINESTRING, POLYGON, MULTPOLYGON.
* This is currently only intended to parse a very simple WKT string

