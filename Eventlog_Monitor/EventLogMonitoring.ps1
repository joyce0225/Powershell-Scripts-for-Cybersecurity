
# PowerShell script for Event Log Monitoring

# Define the computer and namespaces to be monitored
$computer = "localhost"
$wmiNS = "root\subscription"

# Create an event filter for monitoring
$filterName = "Win32ServiceModification"
$filterNS = "oot\cimv2"
$query = "Select * from __InstanceModificationEvent within 60 where TargetInstance isa 'Win32_Service' and TargetInstance.Name = 'browser'"

$filterPath = Set-WmiInstance -Class __EventFilter -ComputerName $computer -Namespace $filterNS -Arguments @{
    name = $filterName
    EventNamespace = $filterNS
    QueryLanguage = "WQL"
    Query = $query
}

# Define the script and its properties for the event consumer
$scriptFileName = "C:\Path\To\Your\Script.vbs" # Replace with the actual path to your VBScript
$consumerName = "ServiceEventConsumer"

$consumerPath = Set-WmiInstance -Class ActiveScriptEventConsumer -ComputerName $computer -Namespace $wmiNS -Arguments @{
    name = $consumerName
    ScriptFileName = $scriptFileName
    ScriptingEngine = "VBScript"
}

# Bind the filter to the consumer
Set-WmiInstance -Class __FilterToConsumerBinding -ComputerName $computer -Namespace $wmiNS -Arguments @{
    Filter = $filterPath
    Consumer = $consumerPath
} | Out-Null

# Optional: Check the created instances
Get-WmiObject __EventFilter -ComputerName $computer -Namespace $wmiNS
Get-WmiObject ActiveScriptEventConsumer -ComputerName $computer -Namespace $wmiNS
Get-WmiObject __FilterToConsumerBinding -ComputerName $computer -Namespace $wmiNS
