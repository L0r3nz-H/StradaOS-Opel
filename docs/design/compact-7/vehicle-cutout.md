# Fahrzeugbild mit transparentem Hintergrund

Quelle: `opel-astra-j-reference.jpg` (unverändertes Nutzerfoto).
App-Asset: `app/src/main/assets/opel_astra_j.png`.
Bearbeitung: eingebautes Imagegen-Tool, `transparent_background=true`.
Das PNG wird mit Alphakanal gespeichert und in Android ohne Hintergrundfüllung
geladen; Nutzerfotos bleiben vorrangig. Die JPEG-Originaldatei wird nicht ersetzt.

Verwendeter Prompt:

> Use case: background-extraction. Edit target: the supplied photograph of the silver Opel Astra J. Remove only the black background outside the car and in the spaces under/between the wheels. Return a clean cutout as an actual RGBA PNG with transparent background, no background rectangle or checkerboard pixels. Preserve the exact original car, its full silhouette, camera angle, crop, proportions, silver color, dark windows, mirrors, grille and Opel emblem, headlights, wheels, shadows within the car, and masked license plate. Do not redesign, relight or beautify the vehicle. Keep dark car parts opaque; only the background becomes transparent. Preserve the landscape composition and use minimal transparent padding. Asset type: vehicle photograph for an Android dashboard, composited over a dark gray card.
