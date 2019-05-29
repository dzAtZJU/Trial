#  Arch

## Cell Contents
### Global Contents
Update these only in collectionview data source
### Timing Contents
Update these only in designate places. Unlike Global Contents is accurate, Timing Contents is likely to be dirty.

## Event Triggers
### User Interaction
### Asyn Response

## Concepts
### mount/unmount
how cell, in response to interaction, manages video with its state 
### fullscreenVideo
Independent of cell, fullscreenVideo is relative to the scene

## Data Flow
1. blank cell
2. videoId
3. thumbnail url
4. thumbnail image data
5. Now Have YoutubeVideoData
6. Video

## Layout
1. viewport center changes
2. recalcu triangle & baricentric
3. If triangle triple changes, use new layout 

## Error Handling

