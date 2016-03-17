# halium
## A nifty little Tor monitor

halium is a web application which queries
[Onionoo](https://onionoo.torproject.org) for data on nodes in the Tor network.
This data is aggregated and presented in a (more or less) visually appealing
way.

halium uses Haskell and Yesod under the hood. It also makes use of onionhoo, an
Onionoo-client written in Haskell by the same author of halium.

**Please note that this software is work in progress and crazily unstable**
It should not be used in production (yet) and its interface is likely to change
a lot.

### Installation
```
git submodule init
git submodule update
stack build
# grab a snack and beverage...
stack exec -- yesod devel
```


### Instructions
Once you're up and running, point your browser to the warp-instance spun up by
Yesod (usually at `localhost:3000`) and type a search query into the field.

Queries you might want to try out:
- by fingerprint: **B204DE75B37064EF6A4C6BAF955C5724578D0B32**
- by nickname: **cry**
- by IP: **192.42.115.101**


Or simply click any of the Top 10 relays in the right column.
