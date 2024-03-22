# 🎨 PowerShell-Profile V0.8

<a name="top"></a>

![](./media/powershell.png)

My PowerShell Profile (WIP)

This is highly inspired by ([Chris Titus](https://github.com/ChrisTitusTech)) and ([Jan de Dobbeleer](https://github.com/JanDeDobbeleer)).

> [!IMPORTANT]
> The Profile Script is working. If Setup.ps1 fails u need to manual download following Files/Folders:

- Microsoft.PowerShell_profile.ps1
- Ohmyposhv3-v2.json
- environment.json.sample
- module.json.sample
- "Profile"-Folder

Put all those in your !Profile directory.
Change or copy the .sample files to .json
Change the `SampleMode` Variable in `Environment.json`

---

> [!NOTE]
> Done things so far:
>
> - [x] The Auto-Import/Install of selected Modules
> - [x] Some critical internal Functions
> - [x] The overall package
> - [x] The Setup-Script
> - [ ] Documentation

## ⚡ One Line Install (Elevated PowerShell Recommended)

> [!CAUTION]
> Version 0.8: Setup-Script should run without Problems

Execute the following command in an elevated PowerShell window to install the PowerShell profile:

```bash
irm "https://raw.githubusercontent.com/Kaimodo/PowerShell-Profile/main/setup.ps1" | iex
```

Now, enjoy your enhanced and stylish PowerShell experience! 🚀

## Documentation

- [English](./Profile/doc/enUS.md)
- [German](./Profile/doc/deDE.md)

[Back to top](#top)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/D1D1TA89P)
