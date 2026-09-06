Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Clipboard]::GetDataObject().GetFormats()|Sort-Object
