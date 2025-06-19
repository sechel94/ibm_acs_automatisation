


$datum = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
 $datumSc = Get-Date -Format "dd.MM.yyyy HH:mm:ss"

$csvFiles = Get-ChildItem -Path "." -Filter "*.csv"
foreach ($file in $csvFiles) {
    $xmlDoc = New-Object System.Xml.XmlDocument
$root = $xmlDoc.CreateElement("HAScript")
$root.SetAttribute("name", "$($datum)_$($file.BaseName)_output.mac")
$root.SetAttribute("description", "")
$root.SetAttribute("timeout", "60000")
$root.SetAttribute("pausetime", "300")
$root.SetAttribute("promptall", "true")
$root.SetAttribute("blockinput", "true")
$root.SetAttribute("author", "")
$root.SetAttribute("creationdate", "$datumSc")
$root.SetAttribute("supressclearevents", "false")
$root.SetAttribute("usevars", "false")
$root.SetAttribute("ignorepauseforenhancedtn", "true")
$root.SetAttribute("delayifnotenhancedtn", "0")
$root.SetAttribute("ignorepausetimeforenhancedtn", "true")
$root.SetAttribute("continueontimeout", "false")
$xmlDoc.AppendChild($root)

$eventLogInfo = ""
$line=0;
$array = '4[enter], 1[enter], {0}[enter][tab][tab]{1}, [pf3], [pf3]';
$array = $array -split ','
    $lines = Import-Csv -Path $file.FullName -Delimiter ";"
    $contantArr = $array.Count
    $citac = 0;
    for ($i = 0; $i -lt ($lines.Count); $i++) {
        for($u = 0; $u -lt $array.Count; $u++)
        {
            $line = $array[$u].Trim()

    $matches = $line | Select-String -Pattern '\{(\d+)\}' -AllMatches
    if($matches){
                foreach ($lineM in $matches.Matches) {
        $columnIndex = $($lineM.Groups[1].Value) 
        $columnName = ($lines | Get-Member -MemberType NoteProperty)[$columnIndex].Name
        $line = $line -replace "\{$columnIndex\}", $lines[$i].$columnName.Trim()
        }}
        $eventLogInfo += "$($line) \n"
        $screen = $xmlDoc.CreateElement("screen")
        $screen.SetAttribute("name", "Anzeige$($citac)")
        $screen.SetAttribute("entryscreen", "false")
        $screen.SetAttribute("exitscreen", "false")
        $screen.SetAttribute("transient", "false")
        $desc = $xmlDoc.CreateElement("description")
        $screen.AppendChild($desc)

        $actions = $xmlDoc.CreateElement("actions")
        $input = $xmlDoc.CreateElement("input")
        $input.SetAttribute("value", $line)
        $actions.AppendChild($input)
        $screen.AppendChild($actions)

        $nextscreens = $xmlDoc.CreateElement("nextscreens")
        $nextscreens.SetAttribute("timeout", "0")
        $nextscreen = "";
        $citac++
  if ($citac -le ($lines.Count * $array.Count)-1) {
        $nextscreen = $xmlDoc.CreateElement("nextscreen")
        $nextscreen.SetAttribute("name", "Anzeige$($citac)")
                $nextscreens.AppendChild($nextscreen)

        }
$screen.AppendChild($nextscreens)
        $root.AppendChild($screen)
    }}
    $xmlDoc.Save("$env:HOMEPATH\Documents\IBM\iAccessClient\Emulator\$($datum)_$($file.BaseName)_output2.mac")
    $eventLogInfo | Set-Content -Path "O:\13_av planovani\Log_AMS\$($datum)_$($file.BaseName)_output2.log" 
}



# $csvFiles = Get-ChildItem -Path "." -Filter "*.csv"
# $datum = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
# $datumSc = Get-Date -Format "dd.MM.YYYY HH:mm:ss"
# 
# foreach ($file in $csvFiles) {
#    $outputFile = "$env:HOMEPATH\\Documents\IBM\iAccessClient\Emulator\$($datum)_$($file.BaseName)_output.mac"
#    $outputLines = @()
#    $outputLines += '<HAScript name="'+$($datum)+'_'+$($file.BaseName)+'_output.mac" description="" timeout="60000" pausetime="300" promptall="true" blockinput="true" author="" creationdate="'+$datumSc+'" supressclearevents="false" usevars="false" ignorepauseforenhancedtn="true" delayifnotenhancedtn="0" ignorepausetimeforenhancedtn="true" continueontimeout="false">'
#    $startAn = $true
# 
#    $lines = Get-Content $file.FullName | Sort-Object -Unique
#     for ($i = 0; $i -lt $lines.Count; $i += 3) {
#     $line = $lines[$i]
#     
#      $outputLines  +=
#     '<screen name="Anzeige'+$i+'" entryscreen="false" exitscreen="false" transient="false">
#         <description >
#         </description>
#         <actions>
#             <input value="'+$line+' [enter]"  />
#         </actions>
#         <nextscreens timeout="0" >
#             <nextscreen name="Anzeige'+($i+1)+'" />
#         </nextscreens>
#     </screen>'+'
#     <screen name="Anzeige'+($i+1)+'" entryscreen="false" exitscreen="false" transient="false">
#         <description >
#         </description>
#         <actions>
#             <input value="[pf3]"  />
#         </actions>           
#         <nextscreens timeout="0" >
#             <nextscreen name="Anzeige'+($i+2)+'" />
#         </nextscreens>
#     </screen>    
#     <screen name="Anzeige'+($i+2)+'" entryscreen="false" exitscreen="false" transient="false">
#         <description >
#         </description>
#         <actions>
#             <input value="1[enter]"  />
#         </actions>
#    '
#      if ($i -lt $lines.Count - 2)
#         {
#         $outputLines += '<nextscreens timeout="0" >
#             <nextscreen name="Anzeige'+($i)+'" />
#         </nextscreens>
#     </screen>'
#     }
#   if ($i -ge $lines.Count - 2)
#         {
#          $outputLines += '
#         
#     </screen>'
#     
#  }
# 
#    }
#    $outputLines +='</HAScript>'
# 
#    $outputLines | Set-Content -Path $outputFile
# }
# 
