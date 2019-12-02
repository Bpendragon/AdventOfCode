# AdventOfCode
Master repo for all my AoC Solutions

https://adventofcode.com

You can use `src\dailySetup.ps1` to pull your inputs and automatically create solution file(s) simply pass in the year and day (or don't and get the most recent puzzle input), and get your session cookie as described here: https://github.com/wimglenn/advent-of-code-wim/issues/1

## Requirements

Powershell v3 or higher (for `$PSScriptRoot` to behave normally), if you're running Windows 8 or later, you should be good, you can check by opening a Powershell CLI and typing `$PSVersionTable` followed by Enter

Example Output:

```
Name                           Value
----                           -----
PSVersion                      5.1.18362.145
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.18362.145
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```

Windows 7 users can upgrade their Powershell to V3 or higher using [these instructions from Microsoft](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-windows-powershell?view=powershell-6)

Windows, Linux, macOS, and ARM Processor users can install PowerShell Core (also called Powershell v6) here: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-6


## Setup

To set this repo up to handle your input rename `/src/exampleconfig.json` to `config.json` and add your cookie (retrieved following steps in above link).

If you don't want your solutions to be PowerShell files edit the string variables named like `$CodePath` ins `src/dailtSetup.ps1`
[Direct Permalink to line](https://github.com/Bpendragon/AdventOfCode/blob/0fff212612f51bb7b3a74cf7f793ab855b1fb055/src/dailySetup.ps1#L26)

Don't forget to then edit `$BasicLayout`
[direct permalink](https://github.com/Bpendragon/AdventOfCode/blob/0fff212612f51bb7b3a74cf7f793ab855b1fb055/src/dailySetup.ps1#L50). To fill the file in with your preffered options.

It's up to your to set up the rest of your programming environment, compilers/interpreters/etc, and linters to your desired settings. 
