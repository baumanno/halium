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
