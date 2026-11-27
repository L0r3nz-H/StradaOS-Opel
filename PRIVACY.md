# Privacy

StradaOS has **no accounts, advertising, trackers, or analytics**, and does not send your data to its own servers.

## Data and its purpose

| Data | Purpose | Does it leave the device? |
|---|---|---|
| GPS location | Speedometer, map, weather, and the optional oil-change reminder. Only distance travelled is stored locally, not places visited. | Map servers receive requests for the areas to download, as with other online maps. Approximate latitude and longitude are sent to [Open-Meteo](https://open-meteo.com) for weather and, if the device cannot resolve the city name, to [BigDataCloud](https://www.bigdatacloud.com). |
| Now-playing track | Display the song in the player. | Read locally from Android and the Open Headunit notification. If you enable Settings → Music → Search for covers online, the title and artist of songs without artwork are sent to MusicBrainz, iTunes or Deezer to find a cover. |
| Vehicle photo | Display it on the home screen. | No. It is processed and stored on the device. |
| Installed application list | Shortcuts and app drawer. | No. |
| OBD-II engine data, VIN and fault codes | Vehicle panel and voice alerts when a scanner is connected. | Local unless optional AI is configured: requesting a code explanation sends the code, entered vehicle description and current engine data to your chosen provider (Anthropic or an OpenAI-compatible endpoint), using your own API key. VIN is sent only if explicitly enabled in AI settings. Location is never sent. Responses are stored locally. |

## Network connections

- **Maps:** OpenStreetMap community servers, OpenTopoMap, and Esri.
- **Weather:** Open-Meteo, with BigDataCloud for city-name lookup.
- **Offline maps:** only when you choose *Download a map*, a country file is downloaded from `download.mapsforge.org`. The map is then rendered locally without a connection.
- **Optional fault-code AI:** only after configuring your API key in Vehicle → AI settings, requests go to `api.anthropic.com` or your configured endpoint.
- **Optional online cover art:** only when enabled, `musicbrainz.org`, `itunes.apple.com` and `api.deezer.com` receive the title and artist; images come from `coverartarchive.org`, `archive.org`, `mzstatic.com` and `dzcdn.net`. Covers are cached locally. On Android 4.x, a failed secure connection may be retried over unencrypted HTTP with the same title/artist or image data.
- **Updates:** GitHub (`api.github.com`, `raw.githubusercontent.com`) and jsDelivr are used to check for new releases. This can be disabled in *Settings → About*. The separate Opel edition does not offer standard StradaOS updates.

## Permissions

- **Accessibility** (Android Auto cover art): optionally reads Open Headunit notifications to obtain cover art.
- **Notification access** (Android 5+): optionally reads the currently playing track.
- **Storage:** optionally locates or saves offline-map files in `Download/StradaOS`.

Diagnostics exported through *Settings → System → Export diagnostics* are saved on the device. They are shared only if you choose to share them.
