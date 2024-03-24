# Get-MarkdownHelp

Erstellt eine Markdown-Readme-Zeichenfolge aus der kommentarbasierten Hilfe eines Befehls

## Syntax

„PowerShell
Get-MarkdownHelp
[-Source <Objekt>]
[-Command <Objekt>]
[-PSCodePattern <String> = 'PS.*\>']
[-AlternateEOL <String> = '\']
[<CommonParameters>]
„

## Beschreibung

Das Cmdlet [Get-MarkdownHelp][1] ruft die [kommentarbasierte Hilfe][2] ab und konvertiert sie in eine Markdown-Seite
ähnlich den allgemeinen Online-PowerShell-Hilfeseiten (z. B. [`Get-Content`](https://go.microsoft.com/fwlink/?LinkID=113310)).
Beachten Sie, dass dieses Cmdlet „XML“-basierte Hilfedateien _nicht_ unterstützt, aber über einige zusätzliche Funktionen für kommentarbasierte verfügt
Hilfe im Gegensatz zum nativen [platyPS][3] [`New-MarkdownHelp`](https://github.com/PowerShell/platyPS/blob/master/docs/New-MarkdownHelp.md):

- **Codeblöcke**

Um Codeblöcke zu erstellen, rücken Sie jede Zeile des Blocks um mindestens vier Leerzeichen oder einen Tabulator relativ zum **Texteinzug** ein.
Der **Texteinzug** wird durch den kleinsten Einzug des aktuellen - und des „.SYNOPSIS“-Abschnitts definiert.
Codeblöcke werden für die standardmäßige PowerShell-Farbcodierung automatisch [eingezäunt][4].
Das übliche kommentarbasierte Hilfepräfix für Code („PS. \>“) kann auch zum Definieren von Codezeilen verwendet werden.
Weitere Einzelheiten finden Sie im [-PSCodePattern-Parameter](#-pscodepattern-parameter).

Gemäß der Definition des Standard-Hilfeinterpreters dürfen Codeblöcke (einschließlich abgeschirmter Codeblöcke) keine Hilfeschlüsselwörter enthalten.
Das bedeutet, dass (eingezäunte) Codeblöcke am nächsten Abschnitt enden, der durch „.<help keyword>“ definiert ist.

- **Beispiele mit Titeln**

Beispiele können durch Hinzufügen einer (zusätzlichen) Raute („#“) vor der ersten Zeile im Abschnitt betitelt werden.
Diese Zeile wird aus dem Abschnitt entfernt und der Kopfzeile des Beispiels hinzugefügt.

- **Links**

> Gemäß Markdown-Definition ist der erste Teil eines [Links im Referenzstil][5] mit zwei Klammersätzen formatiert.
> Die erste Klammergruppe umgibt den Text, der verknüpft erscheinen soll. Der zweite Satz Klammern wird angezeigt
> eine Bezeichnung, die auf den Link verweist, den Sie an anderer Stelle in Ihrem Dokument speichern, z. B.: „[rabbit-hole][1]“.
> Der zweite Teil eines Links im Referenzstil ist mit den folgenden Attributen formatiert:

> – Die Bezeichnung in Klammern, direkt gefolgt von einem Doppelpunkt und mindestens einem Leerzeichen (z. B. „[label]:“).
> – Die URL für den Link, die Sie optional in spitze Klammern einschließen können.
> – Der optionale Titel für den Link, den Sie in doppelte Anführungszeichen, einfache Anführungszeichen oder Klammern setzen können.

Für die kommentarbasierte Hilfeimplementierung sollte der zweite Teil automatisch im Abschnitt „.LINK“ platziert werden
am Ende des Dokuments aufgeführt. Die Referenz wird ausgeblendet, wenn die Bezeichnung eine explizite leere Zeichenfolge („““`) ist.

- **Schnelllinks**

Jede Phrase, die aus einer Kombination aus alphanumerischen Zeichen, Leerzeichen, Unterstrichen und Bindestrichen in eckigen Klammern besteht
(z. B. „[mein Link]“) wird mit der (automatischen) Anker-ID im Dokument verknüpft, z. B.: „[mein Link](#mein-Link)“.

> **Hinweis:** Es gibt keine Bestätigung, ob der interne Anker wirklich existiert.

- **Parameter-Links**

**Parameterlinks** ähneln **Quick Links**, beginnen jedoch mit einem Bindestrich und enthalten möglicherweise einen vorhandenen Parameternamen
gefolgt vom Wort „Parameter“. Beispiel: „[-AlternateEOL]“ oder „[-AlternateEOL Parameter]“.
In diesem Beispiel verweist der Parameterlink auf den internen [-AlternateEOL-Parameter](#-alternateeol-parameter).

- **Cmdlet-Links**

**Cmdlet-Links** ähneln **Quick Links**, enthalten jedoch einen Cmdlet-Namen, unter dem die Online-Hilfe bekannt ist. Beispiel: „[Get-Content]“.
In diesem Beispiel verweist der Cmdlet-Link auf die Onlinehilfe des zugehörigen Cmdlets [`Get-Content`](https://go.microsoft.com/fwlink/?LinkID=113310).

## Beispiele

### Beispiel 1: Markdown-Hilfe anzeigen

Dieses Beispiel generiert aus sich selbst eine Hilfeseite für das Markdown-Format und zeigt sie im Standardbrowser an

„PowerShell
.\Get-MarkdownHelp.ps1 .\Show-MarkDown.ps1 |Out-String |Show-Markdown -UseBrowser
„

### Beispiel 2: Markdown-Hilfe auf eine Website kopieren

Dieser Befehl erstellt eine Markdown-Readme-Zeichenfolge für das Cmdlet „Join-Object“ und legt sie in der Zwischenablage ab
damit es z.B. in eine Datei eingefügt werden kann. eine GitHub-Readme-Datei.

„PowerShell
Get-MarkdownHelp Join-Object |Clip
„

### Beispiel 3: Markdown-Hilfe in Datei speichern

Dieser Befehl erstellt eine Markdown-Readme-Zeichenfolge für das Skript „.\MyScript.ps1“ und speichert sie in „Readme.md“.

„PowerShell
Get-MarkdownHelp .\MyScript.ps1 |Set-Content .\Readme.md
„

## Parameter

### <a id="-source">**`-Source <Object>`**</a>

Die Quelle der kommentierten Hilfe.
Dies kann ein Befehl oder ein Modul anhand seines Namens oder Dateispeicherorts sein.

<Tabelle>
<tr><td>Typ:</td><td></td></tr>
<tr><td>Obligatorisch:</td><td>Falsch</td></tr>
<tr><td>Position:</td><td>Benannt</td></tr>
<tr><td>Standardwert:</td><td></td></tr>
<tr><td>Pipeline-Eingabe akzeptieren:</td><td></td></tr>
<tr><td>Platzhalterzeichen akzeptieren:</td><td>Falsch</td></tr>
</table>

### <a id="-command">**`-Befehl <Object>`**</a>

Ein eingebetteter Befehl, der die Parameter oder tatsächliche kommentierte Hilfe enthält.

<Tabelle>
<tr><td>

[Zurück nach oben](../deDE.md)
