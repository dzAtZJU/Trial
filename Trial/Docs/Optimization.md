#  Optimizations
## CPU Consumption

30%
15% js
15% layout

70%

25%
didscroll
loadvideo: webview create

75%
self sizing 40%
apply attributes 20%
collectionviewcell layoutsubview 20%
layoutattributes 20%

## to do
1. batch network
2. https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/AvoidExtraneousGraphicsAndAnimations.html#//apple_ref/doc/uid/TP40015243-CH19-SW1
3. Reduce the number of subviews

## Tips
* Size Images to Image Views
* Reuse and Lazy Load
    * Views
    * Formatter
* Cache, Cache, Cache: Things that are unlikely to change, but are accessed frequently
    * NSURLConnection has such feature
* Use the same data structure at both ends when requesting and receiving the data
* [IndexPath: Data] for Collectionview
* Network Format
    * Json
    * XML has read-in-fly feature
