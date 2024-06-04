![Icon](.assets/icon.png "Title")
# Clear-AzRG.ps1 

`Clear-AzRG.ps1` is a PowerShell script designed to manage clean-up of resource groups in an Azure account. It connects to the specified Azure account, retrieves all resource groups, filters out any groups specified by the user, and then deletes the remaining groups after a specified timeout period.

This script is particularly useful for maintaining clean and organized Azure environments, especially in scenarios where resource groups are dynamically created and need to be cleaned up periodically.

## **Use at your own risk!**
Please be careful when running this script, as it will delete resource groups. Always ensure that you have current backups of any important data stored in the resource groups that this script will target.

Also, while this script does provide a timeout period before deletion begins, it’s important to review the list of resource groups to be deleted and make sure it doesn’t contain any groups you want to keep.

**RESOURCE GROUPS AND OTHER CONTROL-PLANE OBJECTS CAN NOT BE RECOVERED BY THE AZURE ENGINEERING TEAM; ONLY DATA-PLANE RESOURCES LIKE vDISKS! VMs, VMSS, AND SIMILAR OBJECTS WILL BE LOST FOREVER!**

## Requirements
- Azure `az` Modules for Powershell.
    - `Az.Accounts`
    - `Az.Resources`

This can be installed from powershell with the following commands:
```powershell
Install-Module Az.Accounts
Install-Module Az.Resources

# or you can install the entire module
Install-Module Az
```

## Usage
To use the script, you can call it from the PowerShell command line or from a PowerShell script. Here's an example of how to call the script from the command line:

```powershell
.\Clear-AzRG.ps1 -SubscriptionID "your_subscription_id" -TenantID "your_tenant_id" -Exclude @("rg1", "rg2") -Timeout 30

# Alternative version without declaring the array bounds. '@()'
.\Clear-AzRG.ps1 -SubscriptionID "your_subscription_id" -TenantID "your_tenant_id" -Exclude "rg1", "rg2" -Timeout 30

```

In this example, replace "your_subscription_id" and "your_tenant_id" with your actual Azure subscription ID and tenant ID. Replace the Exclusion list the with an array of the resource group names you want to exclude from deletion. You can also adjust the timeout period by replacing 30 with your desired number of seconds.


## Parameters

The script accepts the following parameters:

| Parameter      | Data Type | Default Value | Description |
| -------------- | --------- | ------------- | ----------- |
| SubscriptionID | string    | --          | The subscription ID associated with the Azure account. This is a unique identifier that allows the script to target the correct Azure subscription. This parameter is mandatory. |
| TenantID       | string    | --          | The tenant ID associated with the Azure account. This is a unique identifier that allows the script to target the correct Azure tenant. This parameter is mandatory. |
| Exclude        | array     | --          | An array of resource group names that should be excluded from deletion. This allows you to protect certain resource groups from being deleted by the script. |
| Timeout        | int       | 20            | The time to wait (in seconds) before starting the deletion process. This provides a buffer period for you to cancel the operation if necessary. |


## Run into any issues?
Please open an issue on the repo. Internal MSFT employee? Just ping me on Teams! 😃