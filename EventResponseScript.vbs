
' VBScript to log event information and send an email
Option Explicit

Dim fso, logFile, logFilePath
Dim cdoMessage, smtpServer, fromAddress, toAddress, emailSubject, emailBody

' Log file path
logFilePath = "C:\Path\To\EventLog.txt"

' Email settings
smtpServer = "smtp.yourserver.com" ' Replace with your SMTP server
fromAddress = "youremail@yourdomain.com" ' Replace with your email address
toAddress = "recipient@domain.com" ' Replace with recipient's email address
emailSubject = "Event Notification"
emailBody = "An event has occurred on the system."

' Create File System Object
Set fso = CreateObject("Scripting.FileSystemObject")

' Log the event
If fso.FileExists(logFilePath) Then
    Set logFile = fso.OpenTextFile(logFilePath, 8, True)
Else
    Set logFile = fso.CreateTextFile(logFilePath, True)
End If

logFile.WriteLine("Event occurred at " & Now)
logFile.Close

' Create and send an email
Set cdoMessage = CreateObject("CDO.Message")
With cdoMessage
    .Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
    .Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    .Configuration.Fields.Update

    .From = fromAddress
    .To = toAddress
    .Subject = emailSubject
    .TextBody = emailBody
    .Send
End With

Set cdoMessage = Nothing
Set fso = Nothing
