<#
.SYNOPSIS
    This script connects to an Azure account, retrieves and filters resource groups, and then deletes the filtered resource groups.

.DESCRIPTION
    The script first connects to an Azure account using the provided subscription ID and tenant ID. It then retrieves all resource groups and filters out those specified in the Exclude parameter. The script then waits for a specified timeout period before deleting the filtered resource groups.

.PARAMETER SubscriptionID
    The subscription ID for the Azure account. This parameter is mandatory.

.PARAMETER TenantID
    The tenant ID for the Azure account. This parameter is mandatory.

.PARAMETER Exclude
    An array of resource group names to exclude from deletion.

.PARAMETER Timeout
    The time to wait (in seconds) before starting the deletion process. The default value is 20 seconds.

.EXAMPLE
    .\Clear-AzRG.ps1 -SubscriptionID "your_subscription_id" -TenantID "your_tenant_id" -Exclude @("rg1", "rg2") -Timeout 30

    Alternative version without declaring the array bounds. '@()'
    .\Clear-AzRG.ps1 -SubscriptionID "your_subscription_id" -TenantID "your_tenant_id" -Exclude "rg1", "rg2" -Timeout 30

.NOTES
    WARNING! RESOURCE GROUPS AND OTHER CONTROL-PLANE OBJECTS CAN NOT BE RECOVERED BY THE AZURE ENGINEERING TEAM; ONLY DATA-PLANE RESOURCES LIKE vDISKS! VMs, VMSS, AND SIMILAR OBJECTS WILL BE LOST FOREVER! USE AT YOUR OWN RISK!!

.LINK
    https://github.com/jasimr/clear-azrg
#>

param (
    [Parameter(Mandatory = $true)][string] $SubscriptionID,
    [Parameter(Mandatory = $true)][string] $TenantID,
    [array] $Exclude,
    [int] $Timeout = 20
)

Write-Host "WARNING! RESOURCE GROUPS AND OTHER CONTROL-PLANE OBJECTS CAN NOT BE RECOVERED BY THE AZURE ENGINEERING TEAM(s); ONLY DATA-PLANE RESOURCES LIKE vDISKS! VMs, VMSS, AND SIMILAR OBJECTS WILL BE LOST FOREVER! USE AT YOUR OWN RISK!!" -ForegroundColor Red

# Connect + Set proper context
Connect-AzAccount -Tenant $TenantID -subscription $SubscriptionID -ErrorAction Stop | Out-Null
set-azcontext -tenant $TenantID -subscription $SubscriptionID -ErrorAction Stop | Out-Null

# Get / Filter RGs
$RGs_nExc = (Get-AzResourceGroup -ErrorAction Stop) | Where-Object { $_.ResourceGroupName -notin $Exclude }

# Verbose
write-host ("Excluded Resource Groups:" ) -ForegroundColor Green
$Exclude

# check to see if there are any resouces inscope.
if ($null -eq $RGs_nExc){
    write-host ("`nNo in-scope Resources Groups found. Stopping script run..." ) -ForegroundColor Yellow
    exit
}

Write-Host "`nResource Groups to be deleted:" -ForegroundColor Red
$RGs_nExc.ResourceGroupName
Write-Host ("`nResource Groups will be deleted in {0}s" -f $Timeout) -ForegroundColor red -NoNewline

# C-Style loop - cancel catch
for ($i = 0; $i -ne $Timeout; $i++) {
    if ($i -ne 0 -and $Timeout % $i -eq 0) { Write-Host "." -NoNewline -ForegroundColor red }
    Start-Sleep 1
}
Write-Host "`nStarting Deletion!" -ForegroundColor Red

# Deletion
$RGs_nExc | Remove-AzResourceGroup -force -verbose -ErrorAction Stop | Out-Null

Write-Host "`nDone!" -ForegroundColor Green