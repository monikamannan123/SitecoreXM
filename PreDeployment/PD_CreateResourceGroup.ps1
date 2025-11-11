[CmdletBinding()]
Param
(
    [Parameter(Mandatory = $true)][string]$ResourceGroupName,
    [Parameter(Mandatory = $true)][string]$Location
)

try 
{
    Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
    if ($notPresent)
    {
        Write-Output "Creating resource group"
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Output "Done"
    }
    else
    {
        Write-Output "Resource group already exists, skipping creation"
    }
        
       $RGName = "$(foundation.resourcegroup)"
    #### Import Module 
    Import-Module Az.Resources

    ### Update Tags on Environment ###  
    $tags = (Get-AzResourceGroup -Name $RGName).Tags

    $newTags = @{}
    #1st batch
    $newTags.Add("AppName", "Sitecore 10.4")
    $newTags.Add("ProjectName", "DCX-Sitecore104")
    $newTags.Add("BillingIdentifier", "")
    $newTags.Add("ExpenseType", "Capital")
    $newTags.Add("SNOW#", "")
    $newTags.Add("Owner", "PEREZED@coned.com")
    $newTags.Add("Requestor", "")
    $newTags.Add("Approver", "PEREZED@coned.com")
    $newTags.Add("CreatedBy", "Contractor")
    $newTags.Add("DeploymentType", "Azure DevOps")

    if ($null -ne $tags)
    {
        foreach ($key in $newTags.Keys)
        {
            if (-not($tags.ContainsKey($key)))
            {
                $tags.Add($key, $newTags[$key])
            }
            else
            {
                $tags[$key] = $newTags[$key]
            }
        }
        Set-AzResourceGroup -Tag $tags -Name $RGName 
    }
    else
    {
        Set-AzResourceGroup -Tag $newTags -Name $RGName 
    }

    $group = Get-AzResourceGroup $RGName
    if ($null -ne $group.Tags) 
    {
        $resources = Get-AzResource -ResourceGroupName $group.ResourceGroupName

        foreach ($r in $resources)
        {
            $resourcetags = (Get-AzResource -ResourceId $r.ResourceId).Tags
            if ($resourcetags)
            {
                Write-Host "Tags exist: $($resourcetags)"
                foreach ($key in $group.Tags.Keys)
                {
                    if (-not($resourcetags.ContainsKey($key)))
                    {
                        $resourcetags.Add($key, $group.Tags[$key])
                    }                    
                    else
                    {
                        $resourcetags[$key] = $group.Tags[$key]
                    }
                }
                Set-AzResource -Tag $resourcetags -ResourceId $r.ResourceId -Force
            }
            else
            {
                Write-Host "No existing tags"
                Set-AzResource -Tag $group.Tags -ResourceId $r.ResourceId -Force
            }
        }
    }


}


catch {

    throw $_.Exception.Message
}


