# GeospatialKit

[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)

What is GeospatialKit?

GeospatialKit is an extension to [GeospatialSwift](https://github.com/MonsantoCo/GeospatialSwift) which adds support for cocoa functionaity.

A GeoJsonObject can now be projected as an image or zoomed and rendered to a map.

## Features

* Unit tested with high coverage
* Ongoing development

## Installation

``` github "MonsantoCo/GeospatialKit" ~> 0.1.0 ```

### Geospatial Example

* An Example application which supplies the most common use cases of GeoJson
* Parses all use cases into GeoJsonObjects and displays the options in a table view

## GeospatialCocoa

GeospatialCocoa

* The main interface consists of 2 new sub interface and includes those in the Geospacial Interface from GeospatialSwift. 

### Mapping

GeospatialCocoa.map

* Simple API to assist in displaying a GeoJsonObject on a map
* Easily zoom in on the GeoJsonObject by setting the region to geoJsonObject.boundingBox.region
* Generate overlays and annotations from any GeoJsonObject
* Generate an overlay renderer from any overlay created by the API
* Displays rendered zoomed overlays and annotations on a map view.

### Imaging

GeospatialCocoa.image

* Create an image from any GeoJsonObject using point projection
* Displays an image view as created from a GeoJsonObect
