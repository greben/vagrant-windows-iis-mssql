#http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/

$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
$consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
[void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
$field.SetValue($consoleHost, [Console]::Out)
$field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
$field2.SetValue($consoleHost, [Console]::Out)


Enable-RemoteDesktop

chocolatey feature enable -n=allowGlobalConfirmation

#choco install git 
#choco install nodejs 
#choco install visualstudiocode 

#choco install cygwin
choco install conemu
choco install sublimetext3
#choco install webpicmd

chocolatey feature disable -n=allowGlobalConfirmation

