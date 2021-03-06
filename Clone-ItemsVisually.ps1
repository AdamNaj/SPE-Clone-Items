$source = gi .
$readonly = $false;
$result = 
    Read-Variable `
        -Parameters @{ Name = "source"; Title="Item to Clone"; Root="/sitecore/content"; editor="item"}, 
            @{ Name = "target"; Title="Target"; Root="/sitecore/content"; editor="item"}, `
            @{ Name = "readonly"; Title="Make the clones read-only"} `
        -Title "Clone Item" `
        -Description "Select the location where you want to store the clone." `
        -OkButtonName "Clone"

if ($result -eq "ok") {

    # make sure the target name is unique
    $targetName = $source.Name    
    if (Test-Path "$($target.ProviderPath)\$($targetName)"){
        $targetName = "Copy of $($targetName)"

        if (Test-Path "$($target.ProviderPath)\$($targetName)"){
            $try = 1
            $tryName = $targetName + " " + $try++
            while (Test-Path "$($target.ProviderPath)\$($tryName)"){
                $tryName = $targetName + " " + $try++
            }
            $targetName = $tryName
        }
    }

    # make the clone
    $clone = New-ItemClone -Item $source -Destination $target -Name $targetName -Recurse
    
    # Protect if the checkbox says so
    if($readonly){
        gci -Path $clone.ProviderPath -WithParent | Protect-Item 
    }
}
