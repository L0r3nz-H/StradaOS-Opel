# Privacy

StradaOS has **no accounts, advertising, trackers, or analytics**, and does not send your data to its own servers.

## Data and its purpose

| Data | Purpose | Does it leave the device? |
|---|---|---|
| GPS location | Speedometer, map, weather, and the optional oil-change reminder. Only distance travelled is stored locally, not places visited. | Map servers receive requests for the areas to download, as with other online maps. Approximate latitude and longitude are sent to [Open-Meteo](https://open-meteo.com) for weather and, if the device cannot resolve the city name, to [BigDataCloud](https://www.bigdatacloud.com). |
| Now-playing track | Display the song in the player. | No. It is read locally from Android and the Open Headunit notification. |
| Vehicle photo | Display it on the home screen. | No. It is processed and stored on the device. |
| Installed application list | Shortcuts and app drawer. | No. |

## Network connections

- **Maps:** OpenStreetMap community servers, OpenTopoMap, and Esri.
- **Weather:** Open-Meteo, with BigDataCloud for city-name lookup.
- **Offline maps:** only when you choose *Download a map*, a country file is downloaded from `download.mapsforge.org`. The map is then rendered locally without a connection.
- **Updates:** GitHub (`api.github.com`, `raw.githubusercontent.com`) and jsDelivr are used to check for new releases. This can be disabled in *Settings → About*. The separate Opel edition does not offer standard StradaOS updates.

## Permissions

- **Accessibility** (Android Auto cover art): optionally reads Open Headunit notifications to obtain cover art.
- **Notification access** (Android 5+): optionally reads the currently playing track.
- **Storage:** optionally locates or saves offline-map files in `Download/StradaOS`.

Diagnostics exported through *Settings → System → Export diagnostics* are saved on the device. They are shared only if you choose to share them.
