# Vehicle image with a transparent background

Source: `opel-astra-j-reference.jpg`, the unchanged user-supplied photo.
Application asset: `app/src/main/assets/opel_astra_j.png`.
Edited with the built-in Imagegen tool using `transparent_background=true`.
The PNG retains its alpha channel and is loaded without a background fill. User-supplied vehicle photos take priority. The original JPEG is preserved.

## Generation prompt

> Use case: background-extraction. Edit target: the supplied photograph of the silver Opel Astra J. Remove only the black background outside the car and in the spaces under/between the wheels. Return a clean cutout as an actual RGBA PNG with transparent background, no background rectangle or checkerboard pixels. Preserve the exact original car, its full silhouette, camera angle, crop, proportions, silver color, dark windows, mirrors, grille and Opel emblem, headlights, wheels, shadows within the car, and masked license plate. Do not redesign, relight or beautify the vehicle. Keep dark car parts opaque; only the background becomes transparent. Preserve the landscape composition and use minimal transparent padding. Asset type: vehicle photograph for an Android dashboard, composited over a dark gray card.
