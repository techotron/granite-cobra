import-module awspowershell

remove-variable region -Force -ErrorAction SilentlyContinue
remove-variable awsProfile -Force -ErrorAction SilentlyContinue

#----------------------------------------------
$region = "eu-west-2"
$awsProfile = "snowco-eddy"
$templateBucketName = "snowco-granite-cobra"
$stackName = "granite-cobra"
$keyName = "aws-snowco-key"
#$serviceRole = "aws-elasticbeanstalk-service-role"
#$iamInstanceProfile = "aws-elasticbeanstalk-ec2-role"

#----------------------------------------------

$tagProduct = New-Object Amazon.CloudFormation.Model.Tag
$tagProduct.Key = "Project"
$tagProduct.Value = "granite-cobra"

#----------------------------------------------

$stackNameParam = New-Object -Type Amazon.CloudFormation.Model.Parameter
$stackNameParam.ParameterKey = "stackName"
$stackNameParam.ParameterValue = $stackName

$keyPairParam = New-Object -Type Amazon.CloudFormation.Model.Parameter
$keyPairParam.ParameterKey = "keyName"
$keyPairParam.ParameterValue = $keyName

$serviceRoleParam = New-Object -Type Amazon.CloudFormation.Model.Parameter
$serviceRoleParam.ParameterKey = "serviceRole"
$serviceRoleParam.ParameterValue = $serviceRole

$iamInstanceProfileParam = New-Object -Type Amazon.CloudFormation.Model.Parameter
$iamInstanceProfileParam.ParameterKey = "iamInstanceProfile"
$iamInstanceProfileParam.ParameterValue = $iamInstanceProfile

#----------------------------------------------

Function Get-TemplateHashCheck {

    param(
        [string] $s3TemplateKey,
        [string] $localTemplatePath,
        [string] $tempFolder
    )

    Remove-Variable hashCheck -Force -ErrorAction SilentlyContinue

    $localFile = "$tempFolder\$($s3TemplateKey.split("/")[-1])"
    Copy-S3Object -BucketName $templateBucketName -Key $s3TemplateKey -LocalFile $localFile -ProfileName $awsProfile | Out-Null
    $s3Hash = (Get-FileHash -Path $localFile -Algorithm SHA256).hash
    $localTemplateHash = (Get-FileHash -Path $localTemplatePath -Algorithm SHA256).hash

    if ($s3Hash -ne $localTemplateHash) {

        $Global:hashCheck = "false"

    } elseif ($s3Hash -eq $localTemplateHash) {

        $Global:hashCheck = "true"

    }

}

#----------------------------------------------

$templatePath = "C:\Users\eddy\git\granite-cobra\CobraDb\" # Eddy's Home Computer Path
$dbTemplateFileName = "granite-cobra-dynamodb.yml"
$dbStack = "https://s3.amazonaws.com/$templateBucketName/cf-templates/$dbTemplateFileName"
$dbStackName = "$stackName-dynamodb"

#----------------------------------------------

Get-TemplateHashCheck -s3TemplateKey "cf-templates/$dbTemplateFileName" -localTemplatePath ($templatePath + $dbTemplateFileName) -tempFolder c:\temp

if ($hashCheck -eq "false") {

    Write-S3Object -BucketName $templateBucketName -file ($templatePath + $dbTemplateFileName) -key "cf-templates\$dbTemplateFileName" -ProfileName $awsProfile

    try {

        $stackCheck = get-cfnstack -StackName $dbStackName -Region $region -ProfileName $awsProfile -ErrorAction SilentlyContinue | Out-Null

        } catch {}

    if ($?) {
    
        write-host "Updating $dbStackName..." -ForegroundColor green
        Update-CFNStack -StackName $dbStackName -TemplateURL $dbStack -Region $region -ProfileName $awsProfile -Parameter @($stackNameParam)

    } else {

        write-host "Creating $dbStackName..." -ForegroundColor yellow
        New-CFNStack -StackName $dbStackName -TemplateURL $dbStack -Region $region -ProfileName $awsProfile -Parameter @($stackNameParam)

    }

}
 
#----------------------------------------------