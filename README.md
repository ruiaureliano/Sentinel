# 🚨Sentinel for Xcode [![](https://img.shields.io/badge/license-MIT-eb3d33.svg)](./LICENSE.md)  ![](https://img.shields.io/badge/version-1.0-eb3d33.svg)

## What is Sentinel

Sentinel is a command line that can be integrated with Xcode using a **Run Script Phase** that allow present custom **Warnings** and **Errors**. 

Al rules are defined in a JSON file which is explained below.

## Download or Build

**1.** Download [**Sentinel (1.0)**](https://github.com/ruiaureliano/Sentinel/releases/download/1.0/sentinel.zip).

**2.** You can also build from source by cloning this project.

## Installation

**1.** Open terminal and check your path
```
echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```
**2.** Move **sentinel** to one of those directories, for instance `/usr/local/bin`, then in terminal, type this:

```
open /usr/local/bin
```

**3.** Drag **sentinel** to that folder, you may need to type your password

**4.** Close and reopen terminal and type this command: `sentinel` if you see the following message, that's all 💪 

```
+----------------------------------------+
| USAGE: sentinel [debug|release] [json] |
| VERSION: 1.0                           |
+----------------------------------------+
```
## Xcode Integration

Open Xcode project, navigate to **Targets ► Build Phases**, create a new **Run Script Phase** and enter this:

```bash
if which sentinel >/dev/null; then
    if [[ $CONFIGURATION == "Debug" ]]; then
        sentinel debug $SRCROOT/.debug.json
    elif [[ $CONFIGURATION == "Release" ]]; then
        sentinel release $SRCROOT/.release.json
    fi
else
    echo "warning: Sentinel not installed, download from https://github.com/ruiaureliano/Sentinel"
fi
```

Sentinel uses a JSON file with the rules for show warnings and errors, this particular file we use two separated JSON's, one for `debug` and one for `release`

Each JSON must be like this:

```json
{
    "debug": [
        {
            "rule": "A = 1",
            "message": "⚠️ Yes can be a emoji 🤭",
            "type": "warning",
            "file": "*.swift"
        },
        {
            "rule": "(b|B) = 1",
            "message": "⚠️ Because '\\$1'",
            "type": "warning",
            "file": "*.swift"
        },
        {
            "rule": "if .* == true",
            "message": "⚠️ Avoid this, use 'if flag' instead",
            "type": "warning",
            "file": "*.swift"
        },
        {
            "rule": "if .* == false",
            "message": "⚠️ Avoid this, use 'if !flag' instead",
            "type": "warning",
            "file": "*.swift"
        }
    ]
}
```
```json
{
    "release": [
        {
            "rule": "A = 1",
            "message": "🛑 Yes can be a emoji 🤭",
            "type": "error",
            "file": "*.swift"
        },
        {
            "rule": "(b|B) = 1",
            "message": "🛑 Because '\\$1'",
            "type": "error",
            "file": "*.swift"
        },
        {
            "rule": "if .* == true",
            "message": "🛑 Avoid this, use 'if flag' instead",
            "type": "error",
            "file": "*.swift"
        },
        {
            "rule": "if .* == false",
            "message": "🛑 Avoid this, use 'if !flag' instead",
            "type": "error",
            "file": "*.swift"
        }
    ]
}
```

The main **key** must be `debug|release` and the **value** is an array of dictionaries, where each one must have this keys: `rule`, `message`, `type`, `file`

## Samples

**1.** Build and Run **Samples** project.

## Output

**1.** When build

![Warnings](https://github.com/ruiaureliano/Sentinel/blob/master/warnings.png?raw=true)

**2.** When archiving

![Errors](https://github.com/ruiaureliano/Sentinel/blob/master/errors.png?raw=true)

---

I'm [Rui Aureliano](http://ruiaureliano.com), iOS and macOS Engineer at [Olá Brothers](https://theolabrothers.com). We make [Sip](https://sipapp.io) 🤓

[Linkedin](https://www.linkedin.com/in/ruiaureliano) | [AngelList](https://angel.co/ruiaureliano) | [Twitter](https://twitter.com/ruiaureliano) | [Github](https://github.com/ruiaureliano) | [Medium](https://medium.com/@ruiaureliano) | [Stackoverflow](https://stackoverflow.com/users/881095/ruiaureliano)

