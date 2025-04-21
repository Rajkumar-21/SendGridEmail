#---------------------------------------
# Function to send email using SendGrid
#---------------------------------------
function Send-EmailWithSendGrid {
    Param (
        [Parameter(Mandatory=$true)]
        [string] $From,

        [Parameter(Mandatory=$true)]
        [String[]] $To,

        [Parameter(Mandatory=$false)]
        [String[]] $Cc = @(),

        [Parameter(Mandatory=$true)]
        [string] $ApiKey,

        [Parameter(Mandatory=$true)]
        [string] $Subject,

        [Parameter(Mandatory=$true)]
        [string] $Body
    )
    
    $headers = @{
        "Authorization" = "Bearer $ApiKey"
        "Content-Type" = "application/json"
    }

    $toAddresses = $To | ForEach-Object { @{ "email" = $_ } }
    $toAddresses = @($toAddresses)
    $ccAddresses = $Cc | ForEach-Object { @{ "email" = $_ } }
    $ccAddresses = @($ccAddresses)

    $jsonRequest = @{
        personalizations = @(
            @{
                to = $toAddresses
                cc = $ccAddresses
                subject = $Subject
            }
        )
        from = @{
            email = $From
        }
        content = @(
            @{
                type = "text/html"
                value = $Body
            }
        )
    } | ConvertTo-Json -Depth 10

    Invoke-RestMethod -Uri "https://api.sendgrid.com/v3/mail/send" -Method Post -Headers $headers -Body $jsonRequest -ContentType "application/json" -Verbose
}

#---------------------
$From = "from_email_user@gmail.com"
$To = @('touser1_email_user@gmail.com','touser2_email_user@gmail.com')  # Replace with actual recipient addresses
$Cc = @('touser3_email_user@gmail.com','touser4_email_user@gmail.com')          # Replace with actual CC addresses if needed
$APIKEY = "API_Secret"
Send-EmailWithSendGrid -From $From -To $To -Cc $Cc -ApiKey $APIKEY -Subject $Subject -Body $Body

#----------------------