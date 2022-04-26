$csv=Import-Csv -Path C:\Users\Администратор\Desktop\asdasd.csv -Delimiter ","
$password = ConvertTo-SecureString "STPUser32" -AsPlainText -Force
foreach ($line in $csv){
$OU = "OU=" + $line.Подразделение + ",DC=corp,DC=stp72,DC=ru"
if ($line.почта){
New-ADUser -Name $line.Фамилия -SamAccountName $line.Фамилия -GivenName $line.Имя -Surname $line.Фамилия -EmailAddress $line.почта -Title $line.Должность -EmployeeNumber $line.Номер -Path $OU -AccountPassword $password -Enabled $True -ChangePasswordAtLogon $True 
} else {
New-ADUser -Name $line.Фамилия -SamAccountName $line.Фамилия -GivenName $line.Имя -Surname $line.Фамилия -Title $line.Должность -EmployeeNumber $line.Номер -Path $OU -AccountPassword $password -Enabled $True -ChangePasswordAtLogon $True 
}
}
#foreach ($line in $csv) {
#New-ADUser -Name $line.Фамилия -GivenName $line.Имя -Surname $line.Фамилия -EmailAddress $line.почта -Department $line.Должность -AccountPassword $password -EmployeeNumber $line.Номер -Path "OU=$line.Подразделение,DC=corp,DC=stp72,DC=ru"
#$OU = "OU=" + $line.Подразделение + ",DC=corp,DC=stp72,DC=ru"
#echo $OU
#break
#}